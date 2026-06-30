import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnFilePicked = void Function(String path);

class FilePickerView extends StatelessWidget {
  final List<String> extensions;
  final String label;
  final OnFilePicked onPickDocument;

  const FilePickerView({
    super.key,
    required this.onPickDocument,
    required this.extensions,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilePickerBloc, FilePickerState>(
      listener: (context, state) {
        if (state is FilePickerSuccess) {
          onPickDocument(state.filePath);
        }
      },
      builder: (context, state) {
        if (state is FilePickerLoading) return GlobalWidget.loadingView();
        return OutlinedButton.icon(
          onPressed: () {
            // Trigger your BLoC event to start picking the file
            context.read<FilePickerBloc>().add(
              FileSelectedEvent(extensions: extensions),
            );
          },
          icon: const Icon(Icons.upload_file),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}
