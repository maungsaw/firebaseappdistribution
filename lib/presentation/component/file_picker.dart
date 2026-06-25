import 'package:firebaseappdistribution/presentation/presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef OnFilePicked = void Function(String path);

class FilePickerView extends StatelessWidget {
  final OnFilePicked onPickDocument;

  const FilePickerView({super.key, required this.onPickDocument});

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
        return Center(
          child: ElevatedButton.icon(
            onPressed: () {
              // Trigger your BLoC event to start picking the file
              context.read<FilePickerBloc>().add(FileSelectedEvent());
            },
            icon: const Icon(Icons.upload_file),
            label: const Text('Pick a Document'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[900],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}
