import 'dart:io';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final VoidCallback onImageTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.imageFile,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onImageTap,
      child: CircleAvatar(
        radius: 50,
        backgroundImage: imageFile != null
            ? FileImage(imageFile!)
            : (imageUrl != null ? NetworkImage(imageUrl!) : null),
        child: imageFile == null && imageUrl == null
            ? const Icon(Icons.person, size: 50)
            : null,
      ),
    );
  }
}
