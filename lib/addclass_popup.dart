import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manifest/addclass_textfield.dart';

Future<Map<String, String>?> addClassPopup(BuildContext context) async {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController imageUrl = TextEditingController();
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
                    controller: imageUrl,
                    labelText: 'image url',
                    icon: Icons.link_rounded,
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
              CupertinoButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(null); // Close dialog without saving
                },
                child: const Text(
                  "Cancel",
                ),
              ),
              CupertinoButton(
                onPressed: () {
                  if (name.text.isEmpty || imageUrl.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please fill all required fields"),
                      ),
                    );
                    return;
                  }
                  if (!Uri.tryParse(imageUrl.text.trim())!.hasAbsolutePath ??
                      false) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please enter a valid URL"),
                      ),
                    );
                    return;
                  }
                  Navigator.of(context).pop({
                    "name": name.text.trim(),
                    "description": description.text.trim(),
                    "image": imageUrl.text.trim(),
                    "is_consumable": isConsumable.toString(),
                  });
                },
                child: const Text("Submit"),
              )
            ],
          );
        });
      });
}
