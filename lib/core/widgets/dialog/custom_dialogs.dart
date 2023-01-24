
import 'package:sizer/sizer.dart';

import '../../../config/export.dart';

class CustomDialogs extends AlertDialog {
  const CustomDialogs({super.key});

  CustomDialogs.showInfoDialog({
    super.key,
    String? text,
    String? contentText,
    VoidCallback? onPressed,
  })  : assert(text != null || contentText != null, "text must not be null"),
        super(
          title: Column(
           mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Image.asset(
                "assets/icons/info.png",
                height: 12.h,
              ),

              SizedBox(height: 2.h),
              BlueBotText.subHeaderText(
                text: text!,
                color: APPColors.appBlack,
                fontSize: 4.w,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 1.h),
              BlueBotText.subHeaderText(
                text: contentText!,
                color: APPColors.appBlack,
                fontSize: 4.w,
                fontWeight: FontWeight.normal,
              ),

              SizedBox(height: 1.h),
              BlueBotButton.primaryFilled(
                  label: 'Apply',
                  onPressed: onPressed
              )
            ],
          ),
        );

  CustomDialogs.withChild();


}
