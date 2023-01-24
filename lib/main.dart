import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config/config.dart';
import 'config/config_dev.dart';
import 'core/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Config.initialize(Flavor.DEV, DevConfig());

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const App());
}
