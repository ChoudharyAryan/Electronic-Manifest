import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manifest/class_repo.dart';

class ConsequencesDialog extends StatefulWidget {
  final List<String> points;
  ClassRepo classRepo;
  final String id;

  ConsequencesDialog(
      {super.key,
      required this.points,
      required this.classRepo,
      required this.id});

  @override
  State<ConsequencesDialog> createState() => _ConsequencesDialogState();
}

class _ConsequencesDialogState extends State<ConsequencesDialog> {
  bool _isAgreed = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        'Consequences',
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.error),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (String point in widget.points)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "• ",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        point,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            Row(
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: (value) {
                    setState(() {
                      _isAgreed = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "I agree to the points above.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: const Text(
            'Cancel',
          ),
        ),
        CupertinoButton(
          onPressed: _isAgreed
              ? () async {
                  final bool response =
                      await widget.classRepo.deleteClass(widget.id);
                  response
                      ? Navigator.of(context).pop(true)
                      : Navigator.of(context).pop(false);
                }
              : null,
          child: const Text(
            'Delete',
          ),
        ),
      ],
    );
  }
}
