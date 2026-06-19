import 'package:flutter/material.dart';

class FilePickerView extends StatelessWidget {
  final Function() onPickDocument;
  const FilePickerView({super.key, required this.onPickDocument});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: onPickDocument,
        icon: const Icon(Icons.add_moderator),
        label: const Text('Pick a Document'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[900],
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
