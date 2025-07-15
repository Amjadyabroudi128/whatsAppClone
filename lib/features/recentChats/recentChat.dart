import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';
import 'package:whatsappclone/messageClass/messageClass.dart';
import '../../Firebase/FirebaseAuth.dart';
import '../../components/TextButton.dart';
import '../../components/flutterToast.dart';
import '../../core/TextStyles.dart';
import '../../core/icons.dart';
import '../chatScreen/chatScreen.dart';
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
      appBar: AppBar(title: const Text("Recent Chats"),automaticallyImplyLeading: false,),
      body: FutureBuilder<List<Messages>>(
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
              final dateTime = (msg.time as Timestamp).toDate();
              return ListTile(
                title: Text(msg.receiverEmail!), // or msg.senderName
                subtitle: Text(msg.text, maxLines: 1, overflow: TextOverflow.ellipsis),
                trailing: Text(DateFormat('HH:mm').format(dateTime)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Testname(
                        receiverId: msg.receiverId!,
                        receiverName: msg.receiverEmail!,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      )
      ,
    );
  }
}


