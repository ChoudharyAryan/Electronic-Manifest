import 'package:flutter/material.dart';
import 'package:manifest/cupertino_button.dart';

class IsconsumableSlider extends StatefulWidget {
  final bool isConsumable;
  final ValueChanged<bool> onToggle;
  const IsconsumableSlider(
      {super.key, required this.isConsumable, required this.onToggle});

  @override
  _IsconsumableSliderState createState() => _IsconsumableSliderState();
}

class _IsconsumableSliderState extends State<IsconsumableSlider> {
  int selectedIndex = 0;

  void setFocus(int index) {
    setState(() {
      selectedIndex = index;
      widget.onToggle(index == 0);
    });
  }

  @override
  void initState() {
    selectedIndex = widget.isConsumable ? 0 : 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary.withOpacity(0.8),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 150),
              alignment: selectedIndex == 0
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: MediaQuery.of(context).size.width /
                      2.5, // Adjust button size
                  height: MediaQuery.of(context).size.height / 20,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: customCupertinoButton(
                  text: 'Consumable',
                  onPressed: () => setFocus(0),
                  textColor: selectedIndex == 0
                      ? Theme.of(context).colorScheme.inversePrimary
                      : null,
                )),
                Container(
                  width: 2, // Thickness of the divider
                  height: MediaQuery.of(context).size.height /
                      25, // Match button height
                  color: Theme.of(context).colorScheme.onInverseSurface,
                ),
                Expanded(
                    child: customCupertinoButton(
                  text: 'Unconsumable',
                  onPressed: () => setFocus(1),
                  textColor: selectedIndex == 1
                      ? Theme.of(context).colorScheme.inversePrimary
                      : null,
                )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
