class RemoteWipeFailure implements Exception {
  const RemoteWipeFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
