import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manifest/addclass_textfield.dart';
import 'package:manifest/class_repo.dart';
import 'package:manifest/cupertino_button.dart';
import 'package:manifest/image_picker.dart';
import 'package:manifest/snackbar.dart';
import 'package:manifest/regex_checker.dart';

Future<Map<String, String>?> addClassPopup(BuildContext context) async {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController classProperties = TextEditingController();
  ClassRepo classRepo = ClassRepo();
  File? selectedFile;
  String imageUrl = '';
  bool isConsumable = false;
  return showAdaptiveDialog<Map<String, String>>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: const Text(
              "Add Class",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: name,
                    labelText: 'name',
                    icon: Icons.text_fields_rounded,
                    isRequired: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller: classProperties,
                    labelText: 'properties',
                    icon: FontAwesomeIcons.gears,
                    isRequired: true,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomTextField(
                    controller: description,
                    labelText: 'description',
                    icon: Icons.description_rounded,
                    isRequired: false,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  CustomImagePicker(
                    onImageSelected: (file) {
                      selectedFile = file;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: isConsumable,
                        onChanged: (value) {
                          isConsumable = !isConsumable;
                          setState(() {});
                        },
                      ),
                      const Text("is Consumable")
                    ],
                  )
                ],
              ),
            ),
            actions: [
              customCupertinoButton(
                text: 'Cancel',
                onPressed: () => Navigator.of(context).pop(null),
              ),
              customCupertinoButton(
                text: 'Submit',
                onPressed: () async {
                  if (name.text.isEmpty ||
                      selectedFile == null ||
                      classProperties.text.isEmpty) {
                    showCustomSnackBar(
                        context: context,
                        message: 'please fill the required fields');
                    return;
                  }
                  imageUrl = await classRepo.uploadImage(
                      name.text, context, selectedFile);
                  if (imageUrl.isEmpty) {
                    showCustomSnackBar(
                        context: context,
                        message: 'unable to retrive image from supabase');
                    return;
                  }

                  if (!isValidProperties(classProperties.text)) {
                    showCustomSnackBar(
                        context: context,
                        message: 'list your properties with commas inbetween');
                    return;
                  }

                  Navigator.of(context).pop(
                    {
                      "name": name.text.trim(),
                      "description": description.text.isNotEmpty
                          ? description.text.trim()
                          : '',
                      "image": imageUrl.trim(),
                      "is_consumable": isConsumable.toString(),
                      "properties": classProperties.text.replaceAll(' ', ''),
                    },
                  );
                },
              )
            ],
          );
        });
      });
}
