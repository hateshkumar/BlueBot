
import 'package:bluebot_turing/config/export.dart';

import 'navigator/bluebot_navigator_observer.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Routes.configureRoutes(NavigatorHelper.router);
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (_, orientation, device) {
      return BlueBotTheme(
          data: BlueBotTheme.themeData,
          child: MaterialApp(
            scaffoldMessengerKey: globalBloc.rootScaffoldMessengerKey,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            title: 'BlueBot',
            builder: (context, child) => DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyText1!,
              child: Scaffold(
                  resizeToAvoidBottomInset: false,                            
                  key: globalBloc.scaffoldKey,
                  body: child),
            ),
            navigatorKey: NavigatorHelper().navigatorKey,
            navigatorObservers: <NavigatorObserver>[
              // routeObserver,
              BlueBotNavigatorObserver(),
            ],
            initialRoute: '/home_screen',
            onGenerateRoute: NavigatorHelper.router.generator,
            theme: BlueBotTheme.generateThemeDataFrombluebotHandsThemeData(
                BlueBotTheme.themeData),
          )

      );
    });
  }

  Future<void> init() async {
    await RepositoryBarrel().initializeAll();
  }
}
