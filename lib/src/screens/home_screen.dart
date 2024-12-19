import 'package:flutter/material.dart';
import 'dart:async'; // For using Future.delayed
import 'dart:convert'; // For encoding and decoding
import 'dart:typed_data'; // For working with byte data
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

  // Function to upload a file using the html package for Flutter Web
  Future<void> _uploadFile() async {
    // Create an input element to trigger file selection
    final html.FileUploadInputElement input = html.FileUploadInputElement()
      ..click();

    input.onChange.listen((e) async {
      final files = input.files;
      if (files!.isEmpty) return;

      final file = files[0];
      final reader = html.FileReader();
      reader.readAsText(file);

      reader.onLoadEnd.listen((e) async {
        final fileContent = reader.result as String;

        setState(() {
          _fileName = file.name;
          _isLoading = true;
        });

        // Simulate delay for minification
        await Future.delayed(const Duration(seconds: 5));

        // Minify the code
        _minifiedCode = CodeMinifierService.minify(fileContent);

        setState(() {
          _isLoading = false;
        });
      });
    });
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
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Code input widget (TextArea)
              CodeInputWidget(controller: _inputController),
              const SizedBox(height: 16),

              // Button for file upload
              ElevatedButton(
                onPressed: _isLoading ? null : _uploadFile,
                child: const Text('Upload File'),
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

              // Button to trigger minification
              ElevatedButton(
                onPressed: _isLoading ? null : _minifyCode,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.0,
                          color: Colors.white,
                        ),
                      )
                    : const Text('Minify Code'),
              ),
              const SizedBox(height: 16),

              // Output of the minified code
              CodeOutputWidget(output: _minifiedCode),

              // Button to download the minified file
              if (_minifiedCode.isNotEmpty) ...[
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _downloadFile,
                  child: const Text('Download Minified File'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
