import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manifest/class_description_widget.dart';

class ClassDetailsCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String? description; // Nullable description
  final bool isConsumable;
  final List<String> properties;

  const ClassDetailsCard({
    super.key,
    required this.imageUrl,
    required this.name,
    this.description, // Nullable parameter
    required this.isConsumable,
    required this.properties,
  });

  @override
  State<ClassDetailsCard> createState() => _ClassDetailsCardState();
}

class _ClassDetailsCardState extends State<ClassDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(
                        Icons.cancel_rounded,
                      ),
                    ),
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  child: Image.network(
                    widget.imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                      widget.isConsumable
                          ? FontAwesomeIcons.check
                          : FontAwesomeIcons.xmark,
                      color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    widget.isConsumable ? "Consumable" : "Non-Consumable",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: widget.properties.map((property) {
                  log(property);
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onInverseSurface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      property[0].toUpperCase() + property.substring(1),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              if (widget.description != null && widget.description!.isNotEmpty)
                DescriptionWidget(
                  description: widget.description,
                ),
              const SizedBox(height: 16),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement modify functionality
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onInverseSurface,
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                    ),
                    child: const Text(
                      'Modify',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.onInverseSurface,
                      minimumSize: const Size(
                        double.infinity,
                        48,
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
