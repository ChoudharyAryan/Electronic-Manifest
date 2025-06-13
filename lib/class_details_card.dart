import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:manifest/class_delete_alert.dart';
import 'package:manifest/class_description_widget.dart';
import 'package:manifest/class_repo.dart';
import 'package:manifest/snackbar.dart';

class ClassDetailsCard extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String? description; // Nullable description
  final bool isConsumable;
  final List<String> properties;
  final ClassRepo classRepo;
  final String id;
  final void Function(bool) onClose;

  const ClassDetailsCard({
    super.key,
    required this.imageUrl,
    required this.id,
    required this.name,
    this.description, // Nullable parameter
    required this.isConsumable,
    required this.properties,
    required this.classRepo,
    required this.onClose,
  });

  @override
  State<ClassDetailsCard> createState() => _ClassDetailsCardState();
}

class _ClassDetailsCardState extends State<ClassDetailsCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _deleteAnimationController;
  late Animation<double> _deleteAnimation;
  bool _isDeleting = false;
  Future<void> showConsequencesDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return ConsequencesDialog(
          points: const [
            "Deleting this item cannot be undone.",
            "All associated data will be permanently removed.",
            "Please make sure you have backed up any required information.",
          ],
          classRepo: widget.classRepo,
          id: widget.id,
        );
      },
    );

    if (result == true) {
      showCustomSnackBar(context: context, message: "class deleted");
      widget.onClose(true);
     Navigator.of(context).pop();
    } else {
      showCustomSnackBar(context: context, message: "unable to delete class");
      null;
    }
  }

  @override
  void initState() {
    super.initState();
    _deleteAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500), // 2 seconds to fill
      vsync: this,
    );
    _deleteAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _deleteAnimationController,
      curve: Curves.linear,
    ));

    _deleteAnimationController.addListener(() {
      if (_deleteAnimationController.value == 1.0) {
        showConsequencesDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _deleteAnimationController.dispose();
    super.dispose();
  }

  void _onDeleteTapDown() {
    setState(() {
      _isDeleting = true;
    });
    _deleteAnimationController.forward();
  }

  void _onDeleteTapUp() {
    setState(() {
      _isDeleting = false;
    });
    // Fast reverse animation (200ms)
    _deleteAnimationController.animateTo(
      0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

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
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25)),
                    child: GestureDetector(
                      onTapDown: (_) => _onDeleteTapDown(),
                      onTapUp: (_) => _onDeleteTapUp(),
                      onTapCancel: _onDeleteTapUp,
                      child: AnimatedBuilder(
                        animation: _deleteAnimation,
                        builder: (context, child) {
                          return Container(
                            height: 48,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onInverseSurface,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Fill animation background
                                FractionallySizedBox(
                                  alignment: Alignment.center,
                                  widthFactor: _deleteAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Theme.of(context)
                                          .colorScheme
                                          .errorContainer,
                                    ),
                                  ),
                                ),
                                // Button content
                                Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_isDeleting) ...[
                                        Icon(
                                          Icons.delete_forever,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      Text(
                                        _isDeleting
                                            ? 'Hold to Delete'
                                            : 'Delete',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
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
