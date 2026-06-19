import 'dart:typed_data';

abstract class FilePickerState {
  final String filePath;
  final String statusMessage;
  final bool isLoading;
  final Uint8List? decryptedBytes;
  FilePickerState({
    this.filePath = '',
    this.statusMessage = '',
    this.isLoading = false,
    this.decryptedBytes,
  });
}

class FilePickerInitial extends FilePickerState {
  FilePickerInitial()
    : super(statusMessage: 'Select a file to upload', isLoading: false);
}

class FilePickerLoading extends FilePickerState {
  FilePickerLoading()
    : super(statusMessage: 'Processing file...', isLoading: true);
}

class FilePickerSuccess extends FilePickerState {
  FilePickerSuccess(String filePath, Uint8List? decryptedBytes)
    : super(
        filePath: filePath,
        statusMessage: 'File processed successfully!',
        isLoading: false,
        decryptedBytes: decryptedBytes,
      );
}

class FilePickerError extends FilePickerState {
  FilePickerError(String errorMessage)
    : super(statusMessage: 'Error: $errorMessage', isLoading: false);
}
