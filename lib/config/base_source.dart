import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:bluebot_turing/config/parser.dart';
import 'package:bluebot_turing/core/dio_extention.dart';

import '../core/blocs/state_blocs/global_bloc.dart';
import '../core/dio_retry.dart';
import '../core/navigator/navigator_helper.dart';
import '../core/widgets/dialog/bluebot_dialog.dart';
import '../core/widgets/dialog/bluebot_error_dialogs.dart';
import '../domain/entites/api_response_model.dart';
import '../domain/entites/bluebot_enum.dart';
import 'config.dart';

/// If we introduce a new version of the API, we need to make that source a part of this file else we wont be able to access the private base methods listed here;
part 'source.dart';

class BlueBotDioOption<String> extends BlueBotEnum<String> {
  const BlueBotDioOption(String value) : super(value);

  static const SnackbarOnError = BlueBotDioOption('snackbarOnError');
  static const AuthorizationOAuth = BlueBotDioOption('oAuth');
}

abstract class BaseSource {
  static _parseAndDecode(String responseBody) {
    return json.decode(responseBody);
  }

  static parseJson(String responseBody) {
    return compute(_parseAndDecode, responseBody);
  }

  final Dio dio = Dio();

  //Can add this transformer to the dio instance to make it work with the isolate transformer
  // ..transformer = DefaultTransformer(jsonDecodeCallback: parseJson);

  final String apiUrl;
  final String methodName;
  final Parser parser;

  final ignoreResponseStatusCodes = [304];

  /// Whether to include oauth token in every request
  final bool useAuthentication = true;

  BaseSource({
    required this.apiUrl,
    required this.methodName,
    required this.parser,
  });

  Options makeOptions(Options options) {
    assert(options.headers == null,
        "We'll need a proper deep copy if you want to set headers");

    return options.copyWith(
      headers: {
        // This allows the server to send gzipped JSON which is a lot smaller
        // Testing shows the trade-off between CPU and bandwidth looks worth it
      },
    );
  }

  //Problem with this is that we need to know the type of the response, so we can parse it accordingly
  //For this case where T is the simple type like Meetup or MeetupWrapper we can do that easily
  //But when T is somethin like APIResponse<T> we need to know the type of T which we cant and then this is the problem
  //so it's better not to parse this in the most inner layer and do it in the outer layer where we know the type
  //TODO: Find a better way to do this
  Future<Response?> _get(
    String url, {
    Map<String, dynamic> dioExtraOptions = const {},
    bool snackbarOnError = true,
    bool throwOnError = false,
    bool retry = true,
  }) async {
    print("url $url");
    try {
      final Response res = await dio.get(
        url,
        options: makeOptions(Options(
          extra: {
            BlueBotDioOption.SnackbarOnError.value: snackbarOnError,
            if (!retry) ...RetryOptions.noRetry().toExtra(),
            ...dioExtraOptions,
          },
        )),
      );

      return res;
    } catch (e) {
      showTimeoutDialog();
      if (throwOnError) rethrow;
    }
    return null;
  }

  Future<Response?> _post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic> dioExtraOptions = const {},
    bool snackbarOnError = false,
    bool throwOnError = true,
    bool retry = false,
  }) async {
    try {
      Response res = await dio.post(
        url,
        data: body,
        options: makeOptions(Options(
          extra: {
            BlueBotDioOption.SnackbarOnError.value: snackbarOnError,
            if (!retry) ...RetryOptions.noRetry().toExtra(),
            ...dioExtraOptions,
          },
        )),
      );
      return res;
    } catch (e) {
      showTimeoutDialog();
      if (throwOnError) rethrow;
    }
    return null;
  }

  Future<Response?> _put(
    String url, {
    required Map<String, dynamic> body,
    Map<String, dynamic> dioExtraOptions = const {},
    bool snackbarOnError = false,
    bool throwOnError = true,
    bool retry = false,
  }) async {
    try {
      Response res = await dio.put(
        url,
        data: body,
        options: makeOptions(Options(
          extra: {
            BlueBotDioOption.SnackbarOnError.value: snackbarOnError,
            if (!retry) ...RetryOptions.noRetry().toExtra(),
            ...dioExtraOptions,
          },
        )),
      );
      return res;
    } catch (e) {
      if (throwOnError) rethrow;
    }
    return null;
  }

  Future<Response?> _delete(
    String url, {
    Map<String, dynamic>? body,
    Map<String, dynamic> dioExtraOptions = const {},
    bool snackbarOnError = false,
    bool throwOnError = true,
    bool retry = false,
  }) async {
    try {
      Response res = await dio.delete(
        url,
        data: body,
        options: makeOptions(Options(
          extra: {
            BlueBotDioOption.SnackbarOnError.value: snackbarOnError,
            if (!retry) ...RetryOptions.noRetry().toExtra(),
            ...dioExtraOptions,
          },
        )),
      );
      return res;
    } catch (e) {
      if (throwOnError) rethrow;
    }
    return null;
  }

  String constructUrlWithoutMethodName(String path) => '$apiUrl/$path';

  String constructUrl(String path) => '$apiUrl/$methodName/$path';

  String constructQueryUrl(String path, Map<String, String?> query) =>
      '$apiUrl/$methodName/$path?${query.entries.where((kv) => kv.value != null).map((kv) => '${kv.key}=${kv.value}').join('&')}';


  showTimeoutDialog() {
    GenericTimeoutDialog(
      actions: [
        BlueBotDialogButton(
          label: "RETRY",
          dialogButtonType: DialogButtonTypes.SECONDARY,
          onPressed: () {
            NavigatorHelper().pop();
            retry();
          },
        ),
      ],
    ).show(dismissible: false);
  }

  retry() async {
    await NavigatorHelper().navigateToScreen('/splash');
  }
}
