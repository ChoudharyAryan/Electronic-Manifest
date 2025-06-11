import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DescriptionWidget extends StatefulWidget {
  final String? description;

  const DescriptionWidget({super.key, this.description});

  @override
  _DescriptionWidgetState createState() => _DescriptionWidgetState();
}

class _DescriptionWidgetState extends State<DescriptionWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.description == null || widget.description!.isEmpty) {
      return const SizedBox
          .shrink(); // Return an empty widget if description is null or empty.
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          AnimatedCrossFade(
            firstChild: Text(
              widget.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.description!,
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Text(_isExpanded ? "Show Less" : "Read More"),
          ),
        ],
      );
    }
  }
}
