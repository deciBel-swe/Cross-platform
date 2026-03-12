import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:decibel/core/theme/app_colors.dart';
import 'dart:io';

class ProfileIcon extends StatefulWidget {
  const ProfileIcon({super.key});

  @override
  State<ProfileIcon> createState() => _ProfileIconState();
}

class _ProfileIconState extends State<ProfileIcon> {
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // FittedBox scales the child to perfectly fit the parent container
    return FittedBox(
      fit: BoxFit.contain,
      child: CircleAvatar(
        radius: 64, // This now acts as your "base" size ratio
        backgroundColor: Colors.grey[200],
        backgroundImage: _selectedImage != null
            ? FileImage(_selectedImage!)
            : null,
        child: _selectedImage == null
            ? const Icon(Icons.person, size: 64, color: Colors.grey)
            : null,
      ),
    );
  }
}
