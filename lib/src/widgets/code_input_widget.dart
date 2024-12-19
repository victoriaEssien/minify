import 'package:flutter/material.dart';

class CodeInputWidget extends StatelessWidget {
  final TextEditingController controller;

  const CodeInputWidget({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 10,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Paste your code here...',
        hintStyle: const TextStyle(color: Colors.grey),
      ),
      style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
      cursorColor: Colors.blue,
    );
  }
}
