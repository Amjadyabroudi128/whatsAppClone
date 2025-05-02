import 'package:flutter/material.dart';

class userDetails extends StatelessWidget {
  final String? name;
  final String? email;
  final String? imageUrl;

  const userDetails({super.key, this.name, this.email, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            imageUrl == null || imageUrl!.isEmpty ? Container(
              height: 200,
              width: 200,
              child: Image.network(
                fit: BoxFit.cover,
                "https://static.vecteezy.com/system/resources/previews/005/544/718/non_2x/profile-icon-design-free-vector.jpg"
              ),
            ): Image.network(imageUrl!),
          ],
        ),
      ),
    );
  }
}
