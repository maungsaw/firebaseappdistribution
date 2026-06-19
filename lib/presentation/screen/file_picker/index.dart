import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebaseappdistribution/presentation/bloc/bloc.dart';
import '../file_picker/pdf_view.dart';
import '../file_picker/picker_view.dart';
import '../global_widget.dart';

class DocumentScreen extends StatelessWidget {
  const DocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilePickerBloc, FilePickerState>(
      listener: (context, state) {
        if (state is FilePickerError) {
          GlobalSnackbar.showError(context, state.statusMessage);
        }
      },
      builder: (context, state) {
        if (state is FilePickerInitial) {
          return FilePickerView(
            onPickDocument: () =>
                context.read<FilePickerBloc>().add(FileSelectedEvent()),
          );
        }
        if (state is FilePickerLoading) {
          return GlobalWidget.loadingView();
        }
        if (state is FilePickerError) {
          return GlobalWidget.errorView(state.statusMessage);
        }
        if (state is FilePickerSuccess) {
          if (state.decryptedBytes == null) {
            return GlobalWidget.loadingView();
          }
          return SecurePdfViewer(
            decryptedBytes: state.decryptedBytes!,
            onClose: () =>
                context.read<FilePickerBloc>().add(FilePickerCancelledEvent()),
          );
        }
        return const Center(child: Text('Unexpected state'));
      },
    );
  }
}
