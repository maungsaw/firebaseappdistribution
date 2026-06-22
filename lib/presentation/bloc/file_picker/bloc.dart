import 'dart:io';
import 'dart:typed_data';
import 'package:file_selector/file_selector.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class FilePickerBloc extends Bloc<FilePickerEvent, FilePickerState> {
  final _storageService = FileStorageService();

  FilePickerBloc() : super(FilePickerInitial()) {
    // FIXED: Added 'async' here and 'await' before the method call
    on<FileSelectedEvent>((event, emit) async {
      await uploadDocument(event, emit);
    });
    on<FilePickerCancelledEvent>((event, emit) {
      emit(FilePickerInitial());
    });
  }

  Future<void> uploadDocument(
    FileSelectedEvent event,
    Emitter<FilePickerState> emit,
  ) async {
    // 1. Pick the raw asset
    final File? rawFile = await _handleFileSelection();
    if (rawFile == null) {
      // Ingestion cancelled by user; safe return without modifying existing state
      return;
    }

    // 2. Transition to processing
    emit(FilePickerLoading());

    try {
      // 3. Delegate execution directly to your secure storage service pipeline
      final String encryptedDestinationPath = await _storageService
          .setDocumentSecurely(rawFile);
      final Uint8List decryptedBytes = await _storageService.getSecureDocument(
        encryptedDestinationPath,
      );

      emit(FilePickerSuccess(encryptedDestinationPath, decryptedBytes));
    } catch (cryptoError) {
      emit(
        FilePickerError(
          'Cryptographic processing failed. Ensure the file is valid and try again.',
        ),
      );
    }
  }

  /// Isolated File Picking Operation using file_selector
  Future<File?> _handleFileSelection() async {
    try {
      const XTypeGroup typeGroup = XTypeGroup(
        label: 'All Documents',
        extensions: <String>['pdf', 'doc', 'docx', 'txt', 'png', 'jpg', 'jpeg'],
      );

      final XFile? result = await openFile(
        acceptedTypeGroups: <XTypeGroup>[typeGroup],
      );

      if (result != null) {
        return File(result.path);
      }
    } catch (_) {
      // Caught gracefully; UI handles errors through state mutations
    }
    return null;
  }
}
