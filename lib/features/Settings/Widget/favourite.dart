import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsappclone/components/kCard.dart';
import 'package:whatsappclone/components/listTilesOptions.dart';

class Favouritescreen extends StatefulWidget {
  const Favouritescreen({super.key});

  @override
  State<Favouritescreen> createState() => _FavouritescreenState();
}

class _FavouritescreenState extends State<Favouritescreen> {
  final String userEmail = FirebaseAuth.instance.currentUser!.email!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favourites"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Favourites")
            .doc(userEmail)
            .collection("myFavourites")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No favourites yet."));
          }
          final favourites = snapshot.data!.docs;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(2.0),
                child: Text(
                  "Favourites",
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: favourites.length,
                  itemBuilder: (context, index) {
                    final favData = favourites[index].data() as Map<String, dynamic>;
                    final name = favData['name'] ?? 'Unknown';

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: kCard(
                        child: Options(
                          context: context,
                          label: Text(name),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
