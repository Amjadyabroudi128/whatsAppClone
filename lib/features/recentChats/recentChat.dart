import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/TextButton.dart';
import '../../components/flutterToast.dart';
import '../../core/TextStyles.dart';
import '../../core/icons.dart';
import '../chatScreen/chatScreen.dart';
import 'Widgets/dateText.dart';
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
      appBar: AppBar(title: const Text("Recent Chats"),automaticallyImplyLeading: false,),
      body: StreamBuilder<QuerySnapshot>(
        stream: service.getRecentChats(user!.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No recent chats."));
          }
          final chats = snapshot.data!.docs;
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final List participants = chat['participants'];
              final otherUserId = participants.firstWhere((id) => id != user!.uid);
              final lastMessage = chat['lastMessage'] ?? "";
              final Timestamp timestamp = chat['lastMessageTime'];
              final dateTime = timestamp.toDate();
              final receiverName = chat['receiverName'] ?? "User";
              return Dismissible(
                key: ValueKey(chat.id),
                direction: DismissDirection.endToStart,
                background: Padding(
                  padding: const EdgeInsets.only(right: 26),
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: icons.deleteIcon,
                  ),
                ),
                confirmDismiss: (direction) async {
                  if (direction == DismissDirection.endToStart) {
                    await showDialog(
                      context: context,
                      builder: (context){
                        return AlertDialog(
                          title: Text("You are about to delete messages with ${receiverName}"),
                          content: Text("Are you sure ? "),
                          actions: [
                            kTextButton(
                              onPressed: (){
                                Navigator.of(context).pop();
                                FocusScope.of(Navigator.of(context).context).unfocus();
                              },
                              child: Text("Cancel"),
                            ),
                            kTextButton(
                              onPressed: () async {
                               await service.deleteRecentChat(chat.id, context);
                              },
                              child: Text("Delete", style: Textstyles.deleteStyle,),
                            ),
                          ],
                        );
                      }
                    );
                  }
                  return false;
                },
                child: Options(
                  context: context,
                  label: Text(receiverName),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: dateText(dateTime: dateTime),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Testname(
                          receiverId: otherUserId,
                          receiverName: receiverName,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

