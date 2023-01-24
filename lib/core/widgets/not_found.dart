import 'package:bluebot_turing/config/export.dart';

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlueBotButton.primaryFilled(
          child: const Text('NO FOUND GO BACK',style: TextStyle(
            color: APPColors.appPrimaryColor
          ),),
          onPressed: () {
            NavigatorHelper().pop();
          },
        ),
      ),
    );
  }
}
