import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/NetworkImage.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/UserCircleAvatar.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/consts.dart';

import '../../../Firebase/FirebaseAuth.dart';
import '../../../components/btmSheet.dart';
import '../../../components/flutterToast.dart';
import '../../../components/iconButton.dart';
import '../../../core/TextStyles.dart';
import '../../../core/icons.dart';
import '../../../globalState.dart';
import '../../chatScreen/Model/MessageModel.dart';
import '../../chatScreen/chatScreen.dart';
import '../../chatScreen/userDetails/recieverdetails.dart';
import '../Widgets/deleteAlert.dart';
import '../Widgets/onlineDot.dart';

class UnreadTab extends StatefulWidget {
  const UnreadTab({super.key});

  @override
  State<UnreadTab> createState() => _UnreadTabState();
}

class _UnreadTabState extends State<UnreadTab> {
  final FirebaseService service = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  String getChatRoomId(String userId1, String userId2) {
    final ids = [userId1, userId2]..sort();
    return ids.join("_");
  }

  // Get list of chat room IDs that have unread messages
  Stream<List<String>> _getChatsWithUnreadMessages(
      List<Messages> messages, String currentUserId) {
    final chatRoomIds = <String>{};

    for (var msg in messages) {
      final isSender = msg.senderId == currentUserId;
      final otherUserId = isSender ? msg.receiverId : msg.senderId;
      if (otherUserId != null) {
        final chatRoomId = getChatRoomId(currentUserId, otherUserId);
        chatRoomIds.add(chatRoomId);
      }
    }

    if (chatRoomIds.isEmpty) {
      return Stream.value([]);
    }

    // Listen to changes in all chat rooms for unread messages
    return FirebaseFirestore.instance
        .collectionGroup('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) {
      final unreadChatRooms = <String>{};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final senderId = data['senderId'] as String?;
        if (senderId != null) {
          final chatRoomId = getChatRoomId(currentUserId, senderId);
          if (chatRoomIds.contains(chatRoomId)) {
            unreadChatRooms.add(chatRoomId);
          }
        }
      }
      return unreadChatRooms.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Messages>>(
      future: service.getAllLastMessages(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final messages = snapshot.data!;

        final currentUserId = user!.uid;

        return StreamBuilder<List<String>>(
          stream: _getChatsWithUnreadMessages(messages, currentUserId),
          builder: (context, unreadSnapshot) {
            if (!unreadSnapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final chatsWithUnread = unreadSnapshot.data!;
            if (chatsWithUnread.isEmpty) {
              return const Center(child: Text("No unread messages."));
            }

            // Filter messages to only show those with unread
            final unreadMessages = messages.where((msg) {
              final isSender = msg.senderId == currentUserId;
              final otherUserId = isSender ? msg.receiverId : msg.senderId;
              final chatRoomId = getChatRoomId(currentUserId, otherUserId!);
              return chatsWithUnread.contains(chatRoomId);
            }).toList();

            return ListView.builder(
              itemCount: unreadMessages.length,
              itemBuilder: (context, index) {
                final msg = unreadMessages[index];
                final isSender = msg.senderId == currentUserId;
                final otherUserId = isSender ? msg.receiverId : msg.senderId;
                final otherUserName =
                isSender ? msg.receiverEmail : msg.senderName;
                final chatRoomId = getChatRoomId(currentUserId, otherUserId!);

                return FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(otherUserId)
                      .get(),
                  builder: (context, userSnapshot) {
                    if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                      return const SizedBox.shrink();
                    }

                    final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                    final userImage = userData['image'] ?? '';

                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chat_rooms")
                          .doc(chatRoomId)
                          .collection("messages")
                          .where("receiverId", isEqualTo: currentUserId)
                          .where("isRead", isEqualTo: false)
                          .snapshots(),
                      builder: (context, snapshotUnread) {
                        if (!snapshotUnread.hasData) {
                          return const SizedBox.shrink();
                        }

                        final unreadCount =
                            snapshotUnread.data?.docs.length ?? 0;

                        if (unreadCount == 0) {
                          return const SizedBox.shrink();
                        }

                        return Slidable(
                          startActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              _buildUnreadAction(
                                  chatRoomId, currentUserId, otherUserId),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              CustomSlidableAction(
                                onPressed: (context) async {
                                  await _showOptionsBottomSheet(
                                    context,
                                    otherUserId,
                                    otherUserName,
                                    userImage,
                                    chatRoomId,
                                  );
                                },
                                autoClose: false,
                                child: icons.options,
                              ),
                              CustomSlidableAction(
                                onPressed: (context) async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return deleteAlert(
                                        receiverName: msg.receiverEmail,
                                        context: context,
                                        service: service,
                                        chatRoomId: chatRoomId,
                                      );
                                    },
                                  );
                                },
                                child: icons.deleteIcon,
                              ),
                            ],
                          ),
                          child: _buildChatTile(
                            context,
                            msg,
                            otherUserId,
                            otherUserName,
                            userImage,
                            chatRoomId,
                            unreadCount,
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildUnreadAction(
      String chatRoomId, String currentUserId, String otherUserId) {
    return StreamBuilder<QuerySnapshot>(
      stream: service.isRead(chatRoomId, currentUserId),
      builder: (context, snapshot) {
        final hasUnreadMessages = snapshot.hasData && snapshot.data!.docs.isNotEmpty;
        return CustomSlidableAction(
          onPressed: (context) async {
            if (hasUnreadMessages) {
              await service.markRead(otherUserId);
              myToast("Messages marked as read");
            } else {
              await service.unread(otherUserId);
              myToast("Messages marked as unread");
            }
            setState(() {});
          },
          backgroundColor:
          hasUnreadMessages ? MyColors.familyText : MyColors.unread,
          child: hasUnreadMessages ? icons.read : icons.unread,
        );
      },
    );
  }

  Widget _buildChatTile(
      BuildContext context,
      Messages msg,
      String otherUserId,
      String? otherUserName,
      String userImage,
      String chatRoomId,
      int unreadCount,
      ) {
    final currentUserId = user!.uid;

    return GestureDetector(
      onLongPress: () async {
        final selected = await showMenu<String>(
          context: context,
          items: const [
            PopupMenuItem(value: "delete", child: Text("Delete")),
            PopupMenuItem(value: "read", child: Text("Mark as Read")),
          ],
          position: const .fromLTRB(200, 160, 0, 0),
        );
        if (selected == "delete") {
          await showDialog(
            context: context,
            builder: (context) {
              return deleteAlert(
                receiverName: msg.receiverEmail,
                context: context,
                service: service,
                chatRoomId: chatRoomId,
              );
            },
          );
        } else if (selected == "read") {
          await service.markRead(otherUserId);
          myToast("Messages marked as read");
          setState(() {});
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 14),
        child: Row(
          children: [
            _buildAvatar(otherUserId, otherUserName, userImage),
            Flexible(
              child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                stream: service.presenceStream(otherUserId),
                builder: (context, presenceSnap) {
                  String subtitle = "";
                  if (presenceSnap.hasData && presenceSnap.data!.exists) {
                    final data = presenceSnap.data!.data()!;
                    final bool receiverIsTyping =
                        (data['isTypingTo'] as String?) == currentUserId;
                    if (receiverIsTyping) {
                      subtitle = "Typing";
                    } else {
                      subtitle = (msg.file?.isNotEmpty == true)
                          ? "[file]"
                          : (msg.image?.isNotEmpty == true)
                          ? "[image]"
                          : (msg.text);
                    }
                  }

                  return Options(
                    context: context,
                    label: Row(
                      children: [
                        Expanded(
                          child: Text(
                            otherUserName ?? "Unknown",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(msg.time!.toDate()),
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (unreadCount > 0)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            padding: unreadPadding,
                            decoration: readDecoration(),
                            child: Text(
                              unreadCount.toString(),
                              style: Textstyles.unreadCount,
                            ),
                          ),
                      ],
                    ),
                    onTap: () {
                      currentReceiverId.value = otherUserId;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Testname(
                            receiverId: otherUserId,
                            receiverName: otherUserName ?? "Unknown",
                            image: userImage,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String otherUserId, String? otherUserName, String userImage) {
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: service.presenceStream(otherUserId),
      builder: (context, presenceSnap) {
        bool isOnline = false;
        if (presenceSnap.hasData && presenceSnap.data!.exists) {
          final data = presenceSnap.data!.data()!;
          isOnline = data['isOnline'] == true;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            userImage.isNotEmpty
                ? Padding(
              padding: const EdgeInsets.only(left: 7),
              child: UserImage(userImage: userImage),
            )
                : userNamecircle(otherUserName: otherUserName),
            presenceDot(isOnline),
          ],
        );
      },
    );
  }

  Future<void> _showOptionsBottomSheet(
      BuildContext context,
      String otherUserId,
      String? otherUserName,
      String userImage,
      String chatRoomId,
      ) async {
    await btmSheet(
      context: context,
      builder: (bottomSheetContext) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    if (userImage.isNotEmpty)
                      UserImage(userImage: userImage),
                     const BoxSpacing(mWidth: 6),
                    Text(otherUserName ?? "Unknown"),
                    const Spacer(),
                    kIconButton(
                      myIcon: icons.close,
                      onPressed: () {
                        Navigator.of(bottomSheetContext).pop();
                      },
                    ),
                  ],
                ),
              ),
              kCard(
                child: Column(
                  children: [
                    Options(
                      context: context,
                      label: const Text("User Info"),
                      trailing: icons.getIssueIcon(context),
                      onTap: () async {
                        try {
                          Navigator.of(context).pop();
                          final u = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(otherUserId)
                              .get();
                          if (u.exists) {
                            final data = u.data()!;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => userDetails(
                                  name: data['name'] ?? otherUserName,
                                  email: data['email'] ?? '',
                                  imageUrl: data['image'] ?? '',
                                  bio: data['bio'] ?? '',
                                  link: data['link'] ?? '',
                                  receiverId: otherUserId,
                                ),
                              ),
                            );
                          } else {
                            myToast("User data not found.");
                          }
                        } catch (_) {
                          Navigator.of(context).pop();
                          myToast("Failed to load user data.");
                        }
                      },
                    ),
                    const divider(),
                    StreamBuilder<bool>(
                      stream: service.isChatMutedStream(chatRoomId, otherUserId),
                      builder: (context, snap) {
                        final isMuted = snap.data ?? false;
                        return Options(
                          label: Text(isMuted ? "Unmute" : "Mute"),
                          trailing: isMuted
                              ? icons.mute(context)
                              : icons.volumeUp(context),
                          context: context,
                          onTap: () async {
                            Navigator.of(context).pop();
                            if (isMuted) {
                              await service.unMute(chatRoomId, otherUserId);
                              myToast("Removed from mute");
                            } else {
                              await service.MuteChat(chatRoomId, otherUserId);
                              myToast("Added to mute");
                            }
                          },
                        );
                      },
                    ),
                    const divider(),
                    FutureBuilder<bool>(
                      future: service.isFavourite(otherUserName),
                      builder: (context, favSnap) {
                        final isFav = favSnap.data ?? false;
                        return Options(
                          label: Text(isFav
                              ? "Remove from favourite"
                              : "Add to favourite"),
                          trailing: isFav
                              ? icons.myFavourite(context)
                              : icons.fave(context),
                          context: context,
                          onTap: () async {
                            Navigator.of(context).pop();
                            if (!isFav) {
                              await service.addToFavourite(otherUserName!);
                              myToast("Added to favourites");
                            } else {
                              await service.removeFavourite(otherUserName!);
                              myToast("Removed from favourites");
                            }
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}