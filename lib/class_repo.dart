import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:manifest/class_model.dart';
import 'package:manifest/snackbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClassRepo {
  Future<List<Class>> fetchClasses({required bool isConsumable}) async {
    try {
      List<Map> response = [];
      response = isConsumable
          ? await Supabase.instance.client
              .from('categories')
              .select('*')
              .eq('is_consumable', true)
          : await Supabase.instance.client
              .from('categories')
              .select('*')
              .eq('is_consumable', false);
      List<Class> myClasses = [];
      for (Map myClass in response) {
        if (myClass['name'] != null) {
          myClasses.add(Class.fromJson(myClass));
        }
      }
      return myClasses;
    } catch (e) {
      log('this is the error in the fetchClasses function in class_repo.dart ${e.toString()}');
      log(e.toString());
      return [];
    }
  }

  void addClass(Map<String, dynamic> data) async {
    try {
      final response = await Supabase.instance.client
          .from('categories')
          .insert(data)
          .select();
      if (response.isEmpty) {
        log("Error: No data returned from the insert operation.");
      } else {
        //log("Data inserted successfully: $response");
      }
    } catch (e) {
      log("this is the error in the addClass function in class_repo.dart ${e.toString()}");
    }
  }

    Future<File?> pickImage(ImageSource source) async {
    try {
        final ImagePicker picker = ImagePicker();
        File? selectedImage;
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
          selectedImage = File(pickedFile.path);
        // widget.onImageSelected(selectedImage);
      }
      return selectedImage;
    } catch (e) {
      log("Error picking image: $e");
      return null;
    }
  }
  Future<bool> requestPermission(Permission permission) async {
    // Check current permission status
    final status = await permission.status;

    if (status.isGranted) {
      // If already granted
      return true;
    } else if (status.isDenied || status.isLimited || status.isRestricted) {
      // Request the permission
      final result = await permission.request();
      return result.isGranted;
    }

    // For permissions like "permanently denied," guide the user to the app settings
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false; // User must manually enable the permission
    }
    return false; // Default case for denied or unhandled statuses
  }
  Future<String> uploadImage(String name , BuildContext context, File? selectedFile) async{
     try {
                    final fileName =
                        "class_$name-${DateTime.now().millisecondsSinceEpoch}.jpg";
                    final response = await Supabase.instance.client.storage
                        .from('image-data')
                        .upload(fileName, selectedFile!);
                    final relativePath =
                        response.replaceFirst('image-data/', '');
                    final imageUrl = Supabase.instance.client.storage
                        .from('image-data')
                        .getPublicUrl(relativePath);
                      return imageUrl;
                  } catch (e) {
                    showCustomSnackBar(
                        context: context,
                        message: 'Failed to upload image: $e');
                    return '';
                  }
  }
}
