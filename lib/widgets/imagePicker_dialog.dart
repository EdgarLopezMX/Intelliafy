import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intelliafy_app/providers/auth_notifier.dart';
import 'package:provider/provider.dart';

class ImagePickerDialog extends StatelessWidget {
  final Function(File) onImageSelected;

  const ImagePickerDialog({super.key, required this.onImageSelected});

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final Color primaryColor = Theme.of(context).colorScheme.primary;
    final Color accentColor = Theme.of(context).colorScheme.secondary;
    final Color surfaceColor = Theme.of(context).colorScheme.surface;

    return AlertDialog(
      backgroundColor: surfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Text(
        'Select image from:',
        style: TextStyle(fontSize: 20, color: primaryColor, fontFamily: 'Init'),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildOption(
            context,
            icon: Icons.camera_alt,
            label: 'Camera',
            source: ImageSource.camera,
            authNotifier: authNotifier,
            accentColor: accentColor,
          ),
          const SizedBox(height: 15),
          _buildOption(
            context,
            icon: Icons.image,
            label: 'Gallery',
            source: ImageSource.gallery,
            authNotifier: authNotifier,
            accentColor: accentColor,
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required IconData icon,
    required String label,
    required ImageSource source,
    required AuthNotifier authNotifier,
    required Color accentColor,
  }) {
    return InkWell(
      onTap: () async {
        Navigator.pop(context);
        final File? file = await authNotifier.pickImage(source);
        if (file != null) {
          onImageSelected(file);
        }
      },
      child: Row(
        children: [
          Icon(icon, color: accentColor, size: 30),
          const SizedBox(width: 15),
          Text(
            label,
            style:
                TextStyle(color: accentColor, fontFamily: 'Init', fontSize: 20),
          ),
        ],
      ),
    );
  }
}
