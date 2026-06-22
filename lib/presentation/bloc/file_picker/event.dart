sealed class FilePickerEvent {}

class FileSelectedEvent extends FilePickerEvent {}

class FilePickerCancelledEvent extends FilePickerEvent {}
