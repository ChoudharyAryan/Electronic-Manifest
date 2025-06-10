import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manifest/class_repo.dart';
import 'package:permission_handler/permission_handler.dart';

Future<File?> showImageSourceSheet(BuildContext context) {
  ClassRepo classRepo = ClassRepo();
  Completer<File?> completer = Completer<File?>();
  File? selectedFile;
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (BuildContext context) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                if (await classRepo.requestPermission(Permission.photos)) {
                  Navigator.of(context).pop();
                  selectedFile = await classRepo.pickImage(ImageSource.gallery);
                  completer.complete(selectedFile);
                } else {
                  Navigator.of(context).pop();
                  completer.complete(null);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () async {
                if (await classRepo.requestPermission(Permission.camera)) {
                  Navigator.of(context).pop();
                  selectedFile = await classRepo.pickImage(ImageSource.camera);
                  completer.complete(selectedFile);
                } else {
                  Navigator.of(context).pop();
                  completer.complete(null);
                }
              },
            ),
          ],
        ),
      );
    },
  );
  return completer.future;
}
