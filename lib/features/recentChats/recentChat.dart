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
class RecentChatsScreen extends StatefulWidget {
  const RecentChatsScreen({super.key});

  @override
  State<RecentChatsScreen> createState() => _RecentChatsScreenState();
}

class _RecentChatsScreenState extends State<RecentChatsScreen> {
  final FirebaseService service = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;
  final ValueNotifier<bool> isFav = ValueNotifier<bool>(false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recent Chats"),
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Messages>>(
        future: service.getAllLastMessages(),
        builder: (context, snapshot) {
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
                List<String> ids = [userId1, userId2];
                ids.sort();
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
                  return  Slidable(
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        unreadMessage(otherUserId)
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
                                              if(userImage.isNotEmpty)
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(userImage),
                                                  radius: 20,
                                                ),
                                              const BoxSpacing(mWidth: 6,),
                                              Text(otherUserName!),
                                              const Spacer(),
                                              kIconButton(
                                                myIcon: icons.close,
                                                onPressed: (){
                                                  Navigator.of(bottomSheetContext).pop();
                                                },
                                              )
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
                                                    Navigator.of(context).pop(); // dismiss loading
                                                    final snapshot = await FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(otherUserId)
                                                        .get();
                                                    if (snapshot.exists) {
                                                      final data = snapshot.data()!;
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
                                                  } catch (e) {
                                                    Navigator.of(context).pop(); // dismiss loading
                                                    myToast("Failed to load user data.");
                                                  }
                                                },
                                              ),

                                              const divider(),
                                              StreamBuilder<bool>(
                                                stream: service.isChatMutedStream(chatRoomId, otherUserId),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Padding(
                                                      padding: EdgeInsets.all(16.0),
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  final isMuted = snapshot.data!;
                                                  return Options(
                                                    label: Text(isMuted ? "Unmute" : "Mute"),
                                                    trailing: isMuted ? icons.mute(context) : icons.volumeUp(context),
                                                    context: context,
                                                    onTap: () async {
                                                      if (isMuted) {
                                                        Navigator.of(context).pop();
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
                                              ValueListenableBuilder<bool>(
                                                valueListenable: isFav,
                                                builder: (context, value, _) {
                                                  return Options(
                                                    label: Text(value ? "Remove from favourite" : "Add to favourite"),
                                                    trailing: value ? icons.myFavourite(context) : icons.fave(context),
                                                    context: context,
                                                    onTap: () async {
                                                      Navigator.of(context).pop();
                                                      if (isFav.value = !value) {
                                                        await service.addToFavourite(otherUserName);
                                                        myToast("Added to favourites");
                                                      } else {
                                                        await service.removeFavourite(otherUserName);
                                                        myToast("Removed from favourites");
                                                      }
                                                    },
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
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
                        )
                      ],
                    ),
                    child: GestureDetector(
                      onLongPress: () async {
                        final selected = await showMenu(
                          context: context,
                          items: [
                            const PopupMenuItem(value: "delete", child: Text("Delete")),
                            const PopupMenuItem(value: "unread", child: Text("Mark as Unread")),
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
                          if(userImage.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(userImage),
                                radius: 20,
                              ),
                            ),
                          Flexible(
                            child: Options(
                              context: context,
                              label: StreamBuilder<bool>(
                                stream: service.isChatMutedStream(chatRoomId, otherUserId),
                                builder: (context, snapshot) {
                                  final isMuted = snapshot.data ?? false;
                                  return Row(
                                    children: [
                                    Expanded(
                                    child: Text(
                                    otherUserName!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: 16),
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
                                msg.file != null && msg.file!.isNotEmpty
                                    ? "[file]"
                                    : msg.image != null && msg.image!.isNotEmpty
                                    ? "[image]"
                                    : msg.text,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                                        style:  Textstyles.unreadCount
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
                                    ),  ),
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
    );
  }

   unreadMessage(String otherUserId) {
    return CustomSlidableAction(
      onPressed: (context) async {
        await service.unread(otherUserId);
        myToast("Message marked as unread");
        setState(() {});
        },
      backgroundColor: MyColors.unread,
      child: icons.unread,
    );
  }
}