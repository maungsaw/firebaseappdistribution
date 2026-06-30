import 'dart:io';
import 'dart:typed_data';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';
import 'state.dart';

class FilePickerBloc extends Bloc<FilePickerEvent, FilePickerState> {
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
    final File? rawFile = await FileStorageService.pickFile(event.extensions);
    if (rawFile == null) {
      // Ingestion cancelled by user; safe return without modifying existing state
      return;
    }

    // 2. Transition to processing
    emit(FilePickerLoading());

    try {
      // 3. Delegate execution directly to your secure storage service pipeline
      final String encryptedDestinationPath =
          await FileStorageService.setDocumentSecurely(rawFile);
      final Uint8List decryptedBytes =
          await FileStorageService.getSecureDocument(encryptedDestinationPath);

      emit(FilePickerSuccess(encryptedDestinationPath, decryptedBytes));
    } catch (cryptoError) {
      emit(FilePickerError('$cryptoError'));
    }
  }

  /// Isolated File Picking Operation using file_selector
}
