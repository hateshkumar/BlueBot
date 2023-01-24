import 'package:bluebot_turing/feature/detail/detail_view.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../widgets/not_found.dart';


class RouteHandlers {
  static Handler notFoundHandler = Handler(
      handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
    return NotFoundScreen();
    // return;
  });


  static Handler detailScreenHandler = Handler(
    handlerFunc: (context,  Map<String, dynamic>  parameters) {

      return DetailView(
        data: parameters['data'][0]!,
      );
    },
  );
  static Handler makeHandler(Function creator) =>
      Handler(handlerFunc: (context, parameters) => creator());



}
