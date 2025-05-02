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
        title: Text("${name}"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            imageUrl == null || imageUrl!.isEmpty ? Text("This user has no image") : Image.network(imageUrl!)
          ],
        ),
      ),
    );
  }
}
