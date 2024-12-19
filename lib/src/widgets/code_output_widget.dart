import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard functionality

class CodeOutputWidget extends StatelessWidget {
  final String output;

  const CodeOutputWidget({Key? key, required this.output}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4),
          ),
          child: SelectableText(
            output.isEmpty ? 'Minified code will appear here...' : output,
            style: const TextStyle(fontFamily: 'Courier', fontSize: 14),
          ),
        ),
        if (output.isNotEmpty) ...[
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: output));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Code copied to clipboard!')),
              );
            },
            icon: const Icon(Icons.copy),
            label: const Text('Copy to Clipboard'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal:
                      16.0), // Adjusted padding for less rounded corners
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(8), // Set the border radius to 8-10px
              ),
              textStyle: const TextStyle(fontSize: 16), // Adjust text size
            ),
          )
        ],
      ],
    );
  }
}
