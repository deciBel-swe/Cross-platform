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
    return Stack(
      children: [
        CircleAvatar(
          radius: 64,
          backgroundColor: Colors.grey[200],
          // Logic to switch between selected image and default icon
          backgroundImage: _selectedImage != null
              ? FileImage(_selectedImage!)
              : null, // Ensure this asset exists
          child: _selectedImage == null
              ? const Icon(Icons.person, size: 64, color: Colors.grey)
              : null,
        ),
      ],
    );
  }
}
