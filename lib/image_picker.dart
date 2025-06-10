import 'dart:io';
import 'package:flutter/material.dart';
import 'package:manifest/image_source_sheet.dart';

class CustomImagePicker extends StatefulWidget {
  final Function(File?) onImageSelected;

  const CustomImagePicker({super.key, required this.onImageSelected});

  @override
  State<CustomImagePicker> createState() => _CustomImagePickerState();
}

class _CustomImagePickerState extends State<CustomImagePicker> {
  File? selectedImage;
  @override
  Widget build(BuildContext context) {
    return selectedImage == null
        ? TextButton.icon(
            onPressed: () async {
              selectedImage = await showImageSourceSheet(context);
              widget.onImageSelected(selectedImage);
              setState(() {});
            },
            icon: const Icon(Icons.add_a_photo),
            label: const Text("Select Image"),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.primary,
            ),
          )
        : GestureDetector(
            onTap: () async {
              selectedImage = await showImageSourceSheet(context);
              widget.onImageSelected(selectedImage);
              setState(() {});
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                selectedImage!,
                fit: BoxFit.cover,
              ),
            ),
          );
  }
}
