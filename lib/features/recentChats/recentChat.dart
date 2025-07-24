import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/ListTiles.dart';
import 'package:whatsappclone/components/SizedBox.dart';
import 'package:whatsappclone/components/dividerWidget.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/TextButton.dart';
import '../../components/btmSheet.dart';
import '../../components/flutterToast.dart';
import '../../components/iconButton.dart';
import '../../core/TextStyles.dart';
import '../../core/icons.dart';
import '../../globalState.dart';
import '../chatScreen/chatScreen.dart';
import '../chatScreen/userDetails/recieverdetails.dart';
import 'Widgets/dateText.dart';
import 'Widgets/deleteAlert.dart';
class RecentChatsScreen extends StatefulWidget {
  const RecentChatsScreen({Key? key}) : super(key: key);

  @override
  State<RecentChatsScreen> createState() => _RecentChatsScreenState();
}

class _RecentChatsScreenState extends State<RecentChatsScreen> {
  final FirebaseService service = FirebaseService();
  final User? user = FirebaseAuth.instance.currentUser;
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
                      motion: StretchMotion(),
                      children: [
                        CustomSlidableAction(
                          onPressed: (context) async {
                            await service.unread(otherUserId);
                            myToast("Message marked as unread");
                            setState(() {});
                          },
                          backgroundColor: Colors.lightBlue,
                          child: icons.unread,
                        )
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: StretchMotion(),
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
                                              Text(otherUserName!),
                                              Spacer(),
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
                                                label: Text("User Info"),
                                                trailing: icons.info,
                                                onTap: () async {
                                                  try {
                                                    final snapshot = await FirebaseFirestore.instance
                                                        .collection('users')
                                                        .doc(otherUserId)
                                                        .get();
                                                    Navigator.of(context).pop(); // dismiss loading
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

                                              divider(),
                                              FutureBuilder<bool>(
                                                future: service.isChatMuted(chatRoomId,otherUserId),
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
                                                    trailing: isMuted ? icons.mute : Icon(Icons.volume_up),
                                                    context: context,
                                                    onTap: () async {
                                                      if (isMuted) {
                                                        await service.unMute(chatRoomId, otherUserId);
                                                        myToast("Removed from mute");
                                                      } else {
                                                        await service.MuteChat(chatRoomId, otherUserId);
                                                        myToast("Added to mute");
                                                      }
                                                      Navigator.of(context).pop();
                                                    },
                                                  );
                                                },
                                              ),
                                              divider(),
                                              FutureBuilder<bool>(
                                                future: service.isFavourite(otherUserName),
                                                builder: (context, snapshot) {
                                                  if (!snapshot.hasData) {
                                                    return const Padding(
                                                      padding: EdgeInsets.all(16.0),
                                                      child: CircularProgressIndicator(),
                                                    );
                                                  }
                                                  final isFavourite = snapshot.data!;
                                                  return Options(
                                                    label: Text(isFavourite ? "Remove from favourite" : "Add to favourite"),
                                                    trailing: icons.fave,
                                                    context: context,
                                                    onTap: () async {
                                                      if (isFavourite) {
                                                        await service.removeFavourite(otherUserName);
                                                        myToast("Removed from favourites");
                                                      } else {
                                                        await service.addToFavourite(otherUserName);
                                                        myToast("Added to favourites");
                                                      }
                                                      Navigator.of(context).pop();
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
                            child: icons.options,
                          autoClose: false,
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
                      child: Options(
                        context: context,
                        label: FutureBuilder<bool>(
                          future: service.isChatMuted(chatRoomId, otherUserId),
                          builder: (context, snapshot) {
                            final isMuted = snapshot.data ?? false;
                            return Row(
                              children: [
                                Text(otherUserName!),
                                BoxSpacing(
                                  mWidth: MediaQuery.of(context).size.width * 0.52,
                                ),
                                if (isMuted)
                                  icons.vOff
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
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  unreadCount.toString(),
                                  style: const TextStyle(color: Colors.white, fontSize: 12),
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
                              ),
                            ),
                          );
                        },
                      ),

                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

}