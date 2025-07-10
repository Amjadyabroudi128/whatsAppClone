import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../core/icons.dart';
import '../chatScreen/chatScreen.dart';
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
              String day = DateFormat.yMd().format(dateTime);
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
                    final messagesSnapshot = await FirebaseFirestore.instance
                        .collection('chat_rooms')
                        .doc(chat.id)
                        .collection('messages')
                        .get();
                    // Delete each message
                    for (var doc in messagesSnapshot.docs) {
                      await doc.reference.delete();
                    }
                    await FirebaseFirestore.instance
                        .collection('chat_rooms')
                        .doc(chat.id)
                        .delete();
                    return true; // Confirm dismissal
                  }
                  return false;
                },

                child: ListTile(
                  title: Text(receiverName),
                  subtitle: Text(
                    lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    "${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}",
                    style: const TextStyle(fontSize: 12),
                  ),
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
