sealed class RemoteWipeEvent {}

class WipeUserSubmittedEvent extends RemoteWipeEvent {
  WipeUserSubmittedEvent({required this.userId});

  final String userId;
}

class WipeAckSubmittedEvent extends RemoteWipeEvent {
  WipeAckSubmittedEvent({
    required this.commandId,
    this.success = true,
    this.deviceId,
  });

  final String commandId;
  final bool success;
  final String? deviceId;
}
