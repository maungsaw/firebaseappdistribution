import 'package:firebaseappdistribution/data/data.dart';
import 'package:firebaseappdistribution/presentation/presentation.dart';

import 'talker/app_talker.dart';

class RemoteWipeHandler {
  final RemoteWipeBloc _wipeBloc;
  final AuthBloc _authBloc;

  RemoteWipeHandler(this._wipeBloc, this._authBloc);

  Future<void> executeWipe(VerifyWideDataResponse data) async {
    await DatabaseFileService.cleanDatabase();
    await FileStorageService.removeFolders();
    try {
      final response = await _wipeBloc.wipeUserUseCase(userId: data.userId);
      _authBloc.add(LogoutEvent());
      AppTalker.info('Wipe acknowledged: ${response.toString()}');
    } catch (e) {
      AppTalker.error('Wipe ack failed: $e');
    }
  }
}
