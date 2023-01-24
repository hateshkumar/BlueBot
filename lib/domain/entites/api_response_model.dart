import 'package:bluebot_turing/domain/entites/bluebot_base_model.dart';

import '../../config/index.dart';

class ApiResponse<T> extends BlueBotBaseModel {
  T data;

  ApiResponse._(
      {required this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    assert(dataFactories.containsKey(T),
        'Type not found in dataFactories ${T.toString()}');
    T model = dataFactories[T]!(json) as T;

    return ApiResponse._(
        data: model);
  }
}
