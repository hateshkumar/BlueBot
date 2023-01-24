import 'package:bluebot_turing/config/export.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../core/widgets/image_loader.dart';
import '../../domain/entites/SearchResponse.dart';

class DetailView extends StatelessWidget {
  static const routeName = '/detail_screen/:data';

  final Results data;

  DetailView({Key? key, required this.data}) : super(key: key);

  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: true,
        title:  BlueBotText.headerText(text: data.name,color: APPColors.appPrimaryColor,fontSize: 8.w,),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.h,
              ),
              CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: 25.h,
                  aspectRatio: 12 / 9,
                  viewportFraction: 0.7,
                  enlargeCenterPage: true,
                  initialPage: 2,
                  onPageChanged: (index, reason) {},
                ),
                items: data.photos!.map((e) {
                  return Builder(
                    builder: (BuildContext context) {
                      return SizedBox(
                        width: 100.w,
                        height: 8.h,
                        child: BlueBotImageLoader(
                          imageUrl: e.getPhotoUrl(e.photoReference.toString(),'300'),
                          fit: BoxFit.contain,
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(
                height: 4.h,
              ),

              BlueBotText.subHeaderText(
                text: data.openingHours!.openNow!? "Gym is Open": "Gym is Close",
                fontSize: 20.sp,
                color: const Color(0xFF58585B),
                fontWeight: FontWeight.w700,
                height: 0.7,
              ),

              SizedBox(
                height: 1.5.h,
              ),

              BlueBotText.subHeaderText(
                textAlign: TextAlign.start,
                text: "Business Status",
                fontSize: 12.sp,
                color: APPColors.appBlack,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              BlueBotText.subHeaderText(
                textAlign: TextAlign.start,
                text: data.businessStatus,
                fontSize: 9.sp,
                color: const Color(0xFF58585B),
                height: 1.4,
              ),

              SizedBox(
                height: 1.5.h,
              ),

              BlueBotText.subHeaderText(
                textAlign: TextAlign.start,
                text: "Total Ratting",
                fontSize: 12.sp,
                color: APPColors.appBlack,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              Row(
                children: [
                  BlueBotText.subHeaderText(
                    textAlign: TextAlign.start,
                    text: data.rating.toString(),
                    fontSize: 9.sp,
                    color: const Color(0xFF58585B),
                    height: 1.4,
                  ),

                  RatingBar.builder(
                    initialRating: data.rating!.toDouble(),
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemSize: 12,
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ), onRatingUpdate: (double value) {  },

                  )
                ],
              ),


              SizedBox(
                height: 1.5.h,
              ),

              BlueBotText.subHeaderText(
                textAlign: TextAlign.start,
                text: "Address",
                fontSize: 12.sp,
                color: APPColors.appBlack,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              BlueBotText.subHeaderText(
                textAlign: TextAlign.start,
                text: data.formattedAddress,
                fontSize: 9.sp,
                color: const Color(0xFF58585B),
                height: 1.4,
              ),

              SizedBox(
                height: 4.h,
              ),

              Center(
                child: SizedBox(
                  width: 60.w,
                  height: 8.h,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: BlueBotButton.primaryFilled(
                      label: 'Go Back to Map',
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
