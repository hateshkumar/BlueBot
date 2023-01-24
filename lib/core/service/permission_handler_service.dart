import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/subjects.dart';

import '../widgets/dialog/bluebot_dialog.dart';

enum BlueBotPermission { CONTACTS, LOCATION, STORAGE, PHOTO, NOTIFICATION }

enum BlueBotPermissionStatus { GRANTED, DENIED, PERMANENTLYDENIED }

class PermissionHandlerService {
  static final PermissionHandlerService _instance =
      PermissionHandlerService._internal();
  final BehaviorSubject<BlueBotPermissionStatus> notificaitonPermissionStatus$ =
      BehaviorSubject();
  factory PermissionHandlerService() => _instance;
  PermissionHandlerService._internal();

  // TODO split this into askContactsPermission and askStoragePermission -> cleaner
  Future<BlueBotPermissionStatus> askPermission(
    BlueBotPermission permission,
  ) async {
    PermissionStatus? permissionStatus;
    if (permission == BlueBotPermission.CONTACTS)
      permissionStatus = await _getContactPermission();
    if (permission == BlueBotPermission.STORAGE)
      permissionStatus = await _getStoragePermission();
    if (permission == BlueBotPermission.PHOTO)
      permissionStatus = await _getPhotoPermission();
    if (permission == BlueBotPermission.LOCATION)
      permissionStatus = await _getLocationPermission();
    if (permission == BlueBotPermission.NOTIFICATION)
      permissionStatus = await _getNotificationPermission();
    if (permissionStatus != null) {
      final BlueBotStatus =
          BlueBotPermissionStatusFromPermissionStatus(permissionStatus);
      notificaitonPermissionStatus$.add(BlueBotStatus);
    }
    if (permissionStatus != null && permissionStatus == PermissionStatus.denied)
      return BlueBotPermissionStatus.DENIED;
    else if (permissionStatus != null &&
        permissionStatus == PermissionStatus.permanentlyDenied)
      return BlueBotPermissionStatus.PERMANENTLYDENIED;
    return BlueBotPermissionStatus.GRANTED;
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.permanentlyDenied &&
        permission != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<PermissionStatus> _getLocationPermission() async {
    PermissionStatus permission = await Permission.location.status;
    if (permission != PermissionStatus.permanentlyDenied &&
        permission != PermissionStatus.granted) {
      PermissionStatus permissionStatus = await Permission.location.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<PermissionStatus> _getNotificationPermission() async {
    // if (Platform.isIOS) {
    //   final setting = await FirebaseNotifications().requestPermissionsIOS();
    //   if (setting.authorizationStatus == AuthorizationStatus.authorized)
    //     return PermissionStatus.granted;
    //   else
    //     return PermissionStatus.denied;
    // } else
    return Permission.notification.request();
  }

  Future<PermissionStatus> _getStoragePermission() async {
    PermissionStatus permission = await Permission.storage.status;

    // {Suggestion}, there is no need to check the status of permission
    // even if you call .request() method multiple time, it shows the permission dialog for once only
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.denied) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<PermissionStatus> _getPhotoPermission() async {
    if (Platform.isIOS)
      return Permission.photos.request();
    else
      return Permission.storage.request();
  }

  Future<BlueBotPermissionStatus> checkPermissionStatus(
      BlueBotPermission permission) async {
    PermissionStatus? permissionStatus;
    if (permission == BlueBotPermission.CONTACTS) {
      permissionStatus = await Permission.contacts.status;
    }
    if (permission == BlueBotPermission.STORAGE) {
      permissionStatus = await Permission.storage.status;
    }
    if (permission == BlueBotPermission.NOTIFICATION) {
      // if (Platform.isIOS) {
      //   final status =
      //       await FirebaseNotifications().notificationPermissionStatus();
      //   if (status == AuthorizationStatus.authorized)
      //     permissionStatus = PermissionStatus.granted;
      //   else
      //     permissionStatus = PermissionStatus.denied;
      // } else
      permissionStatus = await Permission.notification.status;
      if (permissionStatus != null) {
        final BlueBotStatus =
            BlueBotPermissionStatusFromPermissionStatus(permissionStatus);
        notificaitonPermissionStatus$.add(BlueBotStatus);
      }
    }
    if (permission == BlueBotPermission.PHOTO) {
      if (Platform.isIOS)
        permissionStatus = await Permission.photos.status;
      else
        permissionStatus = await Permission.storage.status;
    }
    if (permission == BlueBotPermission.LOCATION) {
      permissionStatus = await Permission.location.status;
    }
    // Denied or expired https://github.com/Baseflow/flutter-permission-handler/wiki/Changes-in-6.0.0
    return BlueBotPermissionStatusFromPermissionStatus(permissionStatus);
  }

  BlueBotPermissionStatus BlueBotPermissionStatusFromPermissionStatus(
      PermissionStatus? permissionStatus) {
    if (permissionStatus == PermissionStatus.denied)
      return BlueBotPermissionStatus.DENIED;
    else if (permissionStatus == PermissionStatus.permanentlyDenied ||
        permissionStatus == PermissionStatus.restricted)
      return BlueBotPermissionStatus.PERMANENTLYDENIED;
    return BlueBotPermissionStatus.GRANTED;
  }

  Future<void> showStorageDeniedPermissionDialog(BuildContext context) {
    if (Platform.isIOS)
      return permissionDialog(
        context,
        "Please allow us access to your Files on you device.\n\n"
        "You can change permissions any time in your phone's settings under \"Files\".",
      );
    else
      return permissionDialog(
        context,
        "Please allow us access to your Photos, Files and Media on you device.\n\n"
        "You can change permissions any time in your phone's settings under \"Storage\".",
      );
  }

  Future<void> showPhotosDeniedPermissionDialog(BuildContext context) {
    if (Platform.isIOS)
      return permissionDialog(
        context,
        "Please allow us access to your Photos on you device.\n\n"
        "You can change permissions any time in your phone's settings under \"Photos\".",
      );
    else
      return permissionDialog(
        context,
        "Please allow us access to your Photos, Files and Media on you device.\n\n"
        "You can change permissions any time in your phone's settings under \"Storage\".",
      );
  }

  Future<void> showNotificationDeniedPermissionDialog(BuildContext context) {
    return permissionDialog(
      context,
      "Please allow us access to Notifications on your device.\n\n"
      "You can change permissions any time in your phone's settings under \"Notifications\".",
    );
  }
  

  Future<void> permissionDialog(BuildContext context, String bodyContent) {
    return showDialog(
      context: context,
      builder: (context) {
        return BlueBotInfoDialog(
          title: 'Permission',
          content: Text(bodyContent),
          actions: [
            BlueBotDialogButton(
              label: 'GO TO SETTINGS',
              onPressed: () async {
                await openAppSettings();
              },
            ),
          ],
        );
      },
    );
  }
}
