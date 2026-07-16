import 'package:firebaseappdistribution/data/dto/response/users_wipe_response.dart';

sealed class RemoteWipeState {}

class RemoteWipeInitialState extends RemoteWipeState {}

class RemoteWipeLoadingState extends RemoteWipeState {}

class RemoteWipeUserSuccessState extends RemoteWipeState {
  RemoteWipeUserSuccessState(this.data);

  final UsersWipeResponseModel data;
}

class RemoteWipeAckSuccessState extends RemoteWipeState {}

class RemoteWipeFailureState extends RemoteWipeState {
  RemoteWipeFailureState(this.message);

  final String message;
}
