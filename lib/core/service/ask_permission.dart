import 'package:bluebot_turing/core/service/permission_handler_service.dart';

class AskPermission{

  Future<bool> askPhotoPermission() async {
    final status = await PermissionHandlerService()
        .askPermission(BlueBotPermission.PHOTO);
    if (status != BlueBotPermissionStatus.GRANTED) {
      return false;
    } else {
      return true;
    }
  }
}