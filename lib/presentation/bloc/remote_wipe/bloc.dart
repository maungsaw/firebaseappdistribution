import 'package:dio/dio.dart';
import 'package:firebaseappdistribution/core/core.dart';
import 'package:firebaseappdistribution/domain/error/remote_wipe_failure.dart';
import 'package:firebaseappdistribution/domain/usecase/usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';
import 'state.dart';

class RemoteWipeBloc extends Bloc<RemoteWipeEvent, RemoteWipeState> {
  RemoteWipeBloc({
    required this.wipeUserUseCase,
    required this.wipeAckUseCase,
  }) : super(RemoteWipeInitialState()) {
    on<WipeUserSubmittedEvent>(_onWipeUser);
    on<WipeAckSubmittedEvent>(_onWipeAck);
  }

  final WipeUserUseCase wipeUserUseCase;
  final WipeAckUseCase wipeAckUseCase;

  Future<void> _onWipeUser(
    WipeUserSubmittedEvent event,
    Emitter<RemoteWipeState> emit,
  ) async {
    emit(RemoteWipeLoadingState());
    try {
      final data = await wipeUserUseCase(userId: event.userId);
      AppTalker.info(
        'Remote wipe command sent: commandId=${data.commandId} '
        'status=${data.status} fcmOk=${data.fcmDeliverySucceeded}',
      );
      emit(RemoteWipeUserSuccessState(data));
    } catch (error) {
      emit(RemoteWipeFailureState(_mapError(error)));
    }
  }

  Future<void> _onWipeAck(
    WipeAckSubmittedEvent event,
    Emitter<RemoteWipeState> emit,
  ) async {
    emit(RemoteWipeLoadingState());
    try {
      await wipeAckUseCase(
        commandId: event.commandId,
        success: event.success,
        deviceId: event.deviceId,
      );
      AppTalker.info(
        'Wipe ack sent: commandId=${event.commandId} success=${event.success}',
      );
      emit(RemoteWipeAckSuccessState());
    } catch (error) {
      emit(RemoteWipeFailureState(_mapError(error)));
    }
  }

  String _mapError(Object error) {
    if (error is RemoteWipeFailure) return error.message;
    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map) {
        final message = data['message']?.toString();
        if (message != null && message.isNotEmpty) return message;
      }
      return 'Request failed (${error.response?.statusCode ?? 'network'})';
    }
    return error.toString();
  }
}
