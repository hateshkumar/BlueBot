import 'dart:async';
import 'dart:isolate';

import 'package:flutter/widgets.dart';
import 'package:bluebot_turing/core/widgets/dialog/bluebot_dialog.dart';

import '../blocs/state_blocs/global_bloc.dart';
import '../widgets/dialog/bluebot_error_dialogs.dart';

// Helper class for error functionality
class Errors {
  static setupErrorHandling() {
    // Catch global uncaught Flutter errors
    FlutterError.onError = Errors.onFlutterError;
    //This is now taken over by instabug
    // For errors that happen outside Flutter
    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final List<dynamic> errorAndStacktrace = pair;
    }).sendPort);
  }

  static onFlutterError(FlutterErrorDetails errorDetails) {
    Zone.current.handleUncaughtError(
      errorDetails.exception,
      errorDetails.stack ??
          StackTrace.fromString(
              "IDK what happended here"), //fromString possibly will trhwo an error
    );
  }

  /// Also logs
  static reportAndShowOhNo(
    String log,
    dynamic error, {
    StackTrace? stackTrace,
    String? title,
    String? message,
    List<BlueBotDialogButton>? actions,
  }) async {
    //
    globalBloc.showBlueBotDialog(SomethingWentWrong(
      title: title,
      message: message,
      actions: actions,
    ));
  }

  static toMessage(dynamic error) {
    if (error is Error) {
      return error.toString();
    } else if (error is Exception) {
      return error.toString();
    } else {
      return error?.toString();
    }
  }
}
