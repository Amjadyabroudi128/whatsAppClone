import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/core/MyColors.dart';
import 'package:whatsappclone/core/consts.dart';
import 'package:whatsappclone/features/recentChats/Tabs/FavouriteTab.dart';
import 'package:whatsappclone/features/recentChats/Tabs/UnreadTab.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/btmSheet.dart';
import '../../components/flutterToast.dart';
import '../../components/iconButton.dart';
import '../../core/TextStyles.dart';
import '../../core/icons.dart';
import '../../globalState.dart';
import '../chatScreen/Model/MessageModel.dart';
import '../chatScreen/chatScreen.dart';
import '../chatScreen/userDetails/recieverdetails.dart';
import 'Widgets/deleteAlert.dart';
import 'Widgets/onlineDot.dart';

class RecentChatsScreen extends StatefulWidget {
  const RecentChatsScreen({super.key});

  @override
  State<RecentChatsScreen> createState() => _RecentChatsScreenState();
}

class _RecentChatsScreenState extends State<RecentChatsScreen> {
  final FirebaseService service = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Recent Chats"),
          automaticallyImplyLeading: false,
          bottom: const TabBar(
            tabs: [
              Tab(text: "All"),
              Tab(text: "Favourite"),
              Tab(text: "Unread"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<Messages>>(
              future: service.getAllLastMessages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No recent chats."));
                }
                final messages = snapshot.data!;

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final currentUserId = user!.uid;
                    final isSender = msg.senderId == currentUserId;
                    final otherUserId = isSender ? msg.receiverId : msg.senderId;
                    final otherUserName = isSender ? msg.receiverEmail : msg.senderName;

                    String getChatRoomId(String userId1, String userId2) {
                      final ids = [userId1, userId2]..sort();
                      return ids.join("_");
                    }

                    final chatRoomId = getChatRoomId(currentUserId, otherUserId!);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                      builder: (context, userSnapshot) {
                        if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                          return const SizedBox.shrink();
                        }
                        final userData = userSnapshot.data!.data() as Map<String, dynamic>;
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
                            final unreadCount = snapshotUnread.data?.docs.length ?? 0;

                            return Slidable(
                              startActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  unreadMessages(chatRoomId, currentUserId, otherUserId),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const StretchMotion(),
                                children: [
                                  CustomSlidableAction(
                                    onPressed: (context) async {
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
                                                        CircleAvatar(
                                                          backgroundImage: NetworkImage(userImage),
                                                          radius: 20,
                                                        ),
                                                      const BoxSpacing(mWidth: 6),
                                                      Text(otherUserName!),
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
                                                              // ignore: use_build_context_synchronously
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
                                                            trailing: isMuted ? icons.mute(context) : icons.volumeUp(context),
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
                                                            label: Text(isFav ? "Remove from favourite" : "Add to favourite"),
                                                            trailing: isFav ? icons.myFavourite(context) : icons.fave(context),
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
                              child: GestureDetector(
                                onLongPress: () async {
                                  final selected = await showMenu<String>(
                                    context: context,
                                    items: const [
                                      PopupMenuItem(value: "delete", child: Text("Delete")),
                                      PopupMenuItem(value: "unread", child: Text("Mark as Unread")),
                                    ],
                                    position: const RelativeRect.fromLTRB(200, 160, 0, 0),
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
                                  } else if (selected == "unread") {
                                    await service.unread(otherUserId);
                                    myToast("Message marked as unread");
                                    setState(() {});
                                  }
                                },
                                child: Row(
                                  children: [
                                    // Avatar + presence
                                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
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
                                              child: CircleAvatar(
                                                backgroundImage: NetworkImage(userImage),
                                                radius: 20,
                                              ),
                                            )
                                                : CircleAvatar(
                                              radius: 20,
                                              child: Text(otherUserName![0]),
                                            ),
                                            presenceDot(isOnline),
                                          ],
                                        );
                                      },
                                    ),

                                    // Chat info with typing indicator
                                    Flexible(
                                      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                                        stream: service.presenceStream(otherUserId),
                                        builder: (context, presenceSnap) {
                                          String subtitle = "";
                                          if (presenceSnap.hasData && presenceSnap.data!.exists) {
                                            final data = presenceSnap.data!.data()!;
                                            final bool receiverIsTyping =
                                                (data['isTypingTo'] as String?) == user!.uid;
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
                                            label: StreamBuilder<bool>(
                                              stream: service.isChatMutedStream(chatRoomId, otherUserId),
                                              builder: (context, snapshot) {
                                                final isMuted = snapshot.data ?? false;
                                                final isUnread = unreadCount > 0;
                                                return Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        otherUserName!,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight: isUnread ? FontWeight.w800 : FontWeight.w400,
                                                        ),
                                                      ),
                                                    ),
                                                    if (isMuted)
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8.0),
                                                        child: icons.mute(context),
                                                      ),
                                                  ],
                                                );
                                              },
                                            ),
                                            subtitle: Text(
                                              subtitle,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontWeight: (unreadCount > 0) ? FontWeight.w800 : FontWeight.w400,
                                                fontSize: (unreadCount > 0) ? 19 : 15,
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
                                                    receiverName: otherUserName!,
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
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
            const FavouriteTab(),
            const UnreadTab(),
          ],
        ),
      ),
    );
  }
  StreamBuilder<QuerySnapshot<Object?>> unreadMessages(
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
          backgroundColor: hasUnreadMessages ? MyColors.familyText : MyColors.unread,
          child: hasUnreadMessages ? icons.read : icons.unread,
        );
      },
    );
  }
}
