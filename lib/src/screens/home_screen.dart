import 'package:flutter/material.dart';
import 'dart:async'; // For using Future.delayed
import 'dart:convert'; // For encoding and decoding
import 'dart:typed_data'; // For working with byte data
import 'package:flutter/services.dart'; // For Clipboard functionality
import 'package:file_picker/file_picker.dart'; // For file picker
import 'dart:html' as html; // Correct import for Flutter Web file downloads
import '../widgets/code_input_widget.dart';
import '../widgets/code_output_widget.dart';
import '../services/code_minifier_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _inputController = TextEditingController();
  String _minifiedCode = "";
  bool _isLoading = false;
  String _fileName = "";

  // Function to minify code
  void _minifyCode() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a delay for 5 seconds
    await Future.delayed(const Duration(seconds: 5));

    final inputCode = _inputController.text;
    setState(() {
      _minifiedCode = CodeMinifierService.minify(inputCode);
      _isLoading = false;
    });
  }

  // Function to upload a file
  Future<void> _uploadFile() async {
    // Pick the file
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      final fileBytes = result.files.single.bytes;
      final fileName = result.files.single.name;

      setState(() {
        _fileName = fileName;
      });

      if (fileBytes != null) {
        String fileContent = utf8.decode(fileBytes);

        setState(() {
          _isLoading = true;
        });

        // Simulate delay for minification
        await Future.delayed(const Duration(seconds: 5));

        // Minify the code
        _minifiedCode = CodeMinifierService.minify(fileContent);

        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Function to download the minified file
  void _downloadFile() {
    final encodedFile = utf8.encode(_minifiedCode);
    final blob = html.Blob([Uint8List.fromList(encodedFile)]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download =
          _fileName; // Use the original file name without modifications

    anchor.click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Code Minifier'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(300.0, 24.0, 300.0, 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Code input widget (TextArea)
              CodeInputWidget(controller: _inputController),
              const SizedBox(height: 16),

              // Button to trigger minification (Primary style)
              ElevatedButton(
                onPressed: _isLoading ? null : _minifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Primary color for the button
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0), // Increased vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Slightly rounded corners (8px)
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Minify Code',
                        style: TextStyle(
                          color: Colors.white, // White text color
                          fontSize: 16, // Font size of 16px
                        ),
                      ),
              ),

              const SizedBox(height: 16),

              // Button for file upload
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // White background color
                  side: BorderSide(color: Colors.blue, width: 1), // Blue border
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0), // Increased vertical padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        8.0), // Slightly rounded corners (8px)
                  ),
                ),
                child: Text(
                  'Upload File',
                  style: TextStyle(
                    color: Colors.blue, // Blue text color
                    fontSize: 16, // Font size of 16px
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Display the uploaded file name
              Text(
                _fileName.isEmpty
                    ? 'No file uploaded yet'
                    : 'Uploaded: $_fileName',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Output of the minified code
              CodeOutputWidget(output: _minifiedCode),

              // Button to download the minified file (Secondary style with icon)
              if (_minifiedCode.isNotEmpty) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
  onPressed: _downloadFile,
  icon: const Icon(
    Icons.download,
    color: Colors.white, // Set icon color to white
  ),
  label: const Text(
    'Download Minified File',
    style: TextStyle(
      color: Colors.white, // Set text color to white
      fontSize: 16, // Font size of 16px
    ),
  ),
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue, // Blue background color
    padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0), // Increased padding for less rounded corners
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8), // Border radius of 8-10px
    ),
  ),
)



              ],
            ],
          ),
        ),
      ),
    );
  }
}
