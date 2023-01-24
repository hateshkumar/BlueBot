import 'package:bluebot_turing/config/export.dart';

enum LoaderSize { SMALL, MEDIUM, LARGE }

class BlueBotFullScreenProgressIndicator extends StatelessWidget {
  final bool enabled;
  final Widget child;
  const BlueBotFullScreenProgressIndicator({super.key,
    required this.enabled,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (enabled) {
      return Center(
        child: CircularProgressIndicator(
          color: BlueBotTheme.of(context).colorTheme.buttonPrimary,
          backgroundColor: APPColors.appPrimaryColor,
        ),
      );
    }
    return child;
  }
}
