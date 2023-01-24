import 'package:bluebot_turing/config/export.dart';
import 'package:bluebot_turing/core/widgets/image_loader.dart';
import 'package:bluebot_turing/feature/detail/detail_view.dart';
import 'package:bluebot_turing/feature/home/home_screen_cubit.dart';
import 'package:custom_info_window/custom_info_window.dart';

import '../../core/widgets/triablge_clipper.dart';
import '../../domain/entites/SearchResponse.dart' as S;
import '../../domain/entites/location_model.dart' as loc;
import '../../domain/entites/place_model.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home_screen';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  StreamController<bool> iconController = StreamController<bool>();
  final GlobalKey contentKey = GlobalKey();
  Set<Marker> _markers = {};
  TextEditingController searchController = TextEditingController();

  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CubitProvider<BlueBotBaseState, HomeScreenCubit>(
        create: (context) => HomeScreenCubit(),
        builder: (context, state, bloc) {
          return BlueBotFullScreenProgressIndicator(
            enabled: state.primaryBusy,
            child: Scaffold(
              body: BehaviorSubjectBuilder<PlaceModel>(
                  subject: bloc.selectedAddress$,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return const Empty();
                    PlaceModel myLocation = snapshot.data!;

                    _markers.add(Marker(
                      markerId: const MarkerId('currentLocation'),
                      position: LatLng(myLocation.lat, myLocation.lng),
                      icon: bloc.mapIcon.value,
                    ));

                    return StreamBuilder<bool>(
                        stream: iconController.stream,
                        builder: (context, snapshot) {
                          return Stack(
                            children: [
                              Stack(
                                children: [
                                  BehaviorSubjectBuilder<List<S.Results>?>(
                                      subject: bloc.addressList$,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          addMarker(snapshot.data);
                                        }
                                        return GoogleMap(
                                          mapType: MapType.normal,
                                          myLocationEnabled: false,
                                          zoomControlsEnabled: false,
                                          markers: _markers,
                                          myLocationButtonEnabled: false,
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                myLocation.lat, myLocation.lng),
                                            zoom: 15.0,
                                          ),
                                          onMapCreated:
                                              (GoogleMapController controller) {
                                            _controller.complete(controller);
                                            customInfoWindowController
                                                    .googleMapController =
                                                controller;
                                          },
                                          onCameraMove: (position) {
                                            customInfoWindowController
                                                .onCameraMove!();
                                          },
                                          onCameraIdle: () {},
                                          onTap: (v) {
                                            customInfoWindowController
                                                .hideInfoWindow!();
                                          },
                                          compassEnabled: true,
                                          mapToolbarEnabled: true,
                                        );
                                      }),
                                  CustomInfoWindow(
                                    controller: customInfoWindowController,
                                    height: 125,
                                    width: 200,
                                    offset: 1,
                                  ),
                                ],
                              ),
                              Container(
                                height: 10.h,
                                margin: EdgeInsets.only(top: 2.8.h),
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 10),
                                child: Theme(
                                  data: ThemeData(
                                    primaryColor: const Color(0xffffffff),
                                    primaryColorDark: const Color(0xffffffff),
                                  ),
                                  child: Container(
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffffffff),
                                      border: Border.all(
                                        width: 1.00,
                                        color: const Color(0xffffffff),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(25.00),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Positioned(
                                          left: 10,
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            child: TextFormField(
                                              controller: searchController,
                                              onTap: () async {},
                                              onChanged: (val) {
                                                bloc.searchAddress(
                                                    val, myLocation);
                                              },
                                              style: TextStyle(fontSize: 10.sp),
                                              cursorColor: APPColors.appBlack
                                                  .withOpacity(0.8),
                                              decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'Search here...',
                                                hintStyle: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 25,
                                          child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: GestureDetector(
                                              onTap: () async {
                                                bloc.searchAddress(
                                                    '', myLocation);

                                                customInfoWindowController
                                                    .hideInfoWindow!();

                                                _markers.clear();
                                                _markers.add(Marker(
                                                  markerId: const MarkerId(
                                                      'currentLocation'),
                                                  position: LatLng(
                                                      myLocation.lat,
                                                      myLocation.lng),
                                                  icon: bloc.mapIcon.value,
                                                ));

                                                GoogleMapController controller =
                                                    await _controller.future;
                                                controller.animateCamera(
                                                    CameraUpdate.newCameraPosition(
                                                        // on below line we have given positions of Location 5
                                                        CameraPosition(
                                                  target: LatLng(myLocation.lat,
                                                      myLocation.lng),
                                                  zoom: 14,
                                                )));
                                                bloc.addressList$.sink.add([]);
                                                iconController.sink.add(true);
                                                searchController.clear();
                                              },
                                              child: const Icon(Icons.close,
                                                  color:
                                                      APPColors.appPrimaryColor,
                                                  size: 20.0),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: GestureDetector(
                                              onTap: () async {
                                                loc.Location resetLocation =
                                                    await bloc
                                                        .resetCurrentLocation();
                                                GoogleMapController controller =
                                                    await _controller.future;
                                                controller.animateCamera(
                                                  CameraUpdate
                                                      .newCameraPosition(
                                                    CameraPosition(
                                                        target: LatLng(
                                                            resetLocation.lat,
                                                            resetLocation.long),
                                                        zoom: 15),
                                                  ),
                                                );
                                              },
                                              child: const Icon(
                                                  Icons.my_location_outlined,
                                                  color:
                                                      APPColors.appPrimaryColor,
                                                  size: 20.0),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                  }),
            ),
          );
        });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void addMarker(List<S.Results>? data) {
    for (var e in data!) {
      _markers.add(Marker(
          markerId: MarkerId(e.placeId.toString()),
          position: LatLng(e.geometry!.location!.lat!.toDouble(),
              e.geometry!.location!.lng!.toDouble()),
          icon: BitmapDescriptor.defaultMarker,
          onTap: () {
            customInfoWindowController.addInfoWindow!(
              Column(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [
                          Colors.white,
                          Color(0xffffe6cc),
                        ],
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 1.0),
                          blurRadius: 6.0,
                        ),
                      ],
                    ),
                    height: 75,
                    width: 200,
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: BlueBotImageLoader(
                            imageUrl: e.photos != null
                                ? e.photos!.first.getPhotoUrl(
                                    e.photos!.first.photoReference.toString(),
                                    '50')
                                : "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: 7,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 30.w,
                              height: 3.h,
                              child: Text(
                                e.name!,
                                maxLines: 1,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              width: 30.w,
                              height: 4.h,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          DetailView(data: e)));
                                },
                                child: BlueBotButton.primaryFilled(
                                  label: 'View Detail',
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  ClipPath(
                    clipper: TriangleClipper(),
                    child: Container(
                      color: APPColors.appPrimaryColor,
                      height: 15,
                      width: 20,
                    ),
                  ),
                ],
              ),
              LatLng(e.geometry!.location!.lat!.toDouble(),
                  e.geometry!.location!.lng!.toDouble()),
            );
          }));
    }
    iconController.sink.add(true);
  }
}

class LocationTile extends StatelessWidget {
  final String city;
  final String address;
  final VoidCallback onTap;

  const LocationTile({
    Key? key,
    required this.city,
    required this.address,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlueBotText.subHeaderText(
              text: city,
              fontSize: MediaQuery.of(context).size.width * 0.045,
              textAlign: TextAlign.start,
              color: APPColors.appBlack.withOpacity(0.8),
            ),
            BlueBotText.subHeaderText(
              text: address,
              textAlign: TextAlign.start,
              fontSize: MediaQuery.of(context).size.width * 0.037,
              color: APPColors.appBlack.withOpacity(0.5),
            ),
            Divider(
              color: APPColors.greyText.withOpacity(0.1),
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
