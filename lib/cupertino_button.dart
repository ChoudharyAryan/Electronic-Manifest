// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';

class customCupertinoButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const customCupertinoButton({
    super.key,
    required this.text,
    required this.onPressed
  });
  
  @override
  Widget build(BuildContext context){
    return CupertinoButton(onPressed: onPressed, child: Text(text));
  }
}
