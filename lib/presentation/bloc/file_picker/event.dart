sealed class FilePickerEvent {}

class FileSelectedEvent extends FilePickerEvent {
  final List<String> extensions;

  FileSelectedEvent({required this.extensions});
}

class FilePickerCancelledEvent extends FilePickerEvent {}
