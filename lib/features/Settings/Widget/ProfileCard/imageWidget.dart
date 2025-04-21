import 'package:flutter/material.dart';

class imageWidget extends StatelessWidget {
  const imageWidget({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl == null || imageUrl!.isEmpty
          ? "https://thumbs.dreamstime.com/b/default-avatar-profile-icon-vector-social-media-user-image-182145777.jpg"
          : imageUrl!,
      fit: BoxFit.cover,
      height: 200,
      width: 200,
    );
  }
}
