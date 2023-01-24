import 'package:android_intent/android_intent.dart';
import 'package:bluebot_turing/config/export.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

import '../../core/service/permission_handler_service.dart';
import '../../core/widgets/dialog/custom_dialogs.dart';
import '../../core/widgets/triablge_clipper.dart';
import '../../domain/entites/SearchResponse.dart' as S;
import '../../domain/entites/location_model.dart';
import '../../domain/entites/place_model.dart';

class HomeScreenCubit extends BlueBotBaseCubit<BlueBotBaseState> {
  HomeScreenCubit() : super(BlueBotBaseState.idle()) {
    initialize();
  }

  final BehaviorSubject<PlaceModel> selectedAddress$ =
      BehaviorSubject<PlaceModel>();
  final BehaviorSubject<BitmapDescriptor> mapIcon =
      BehaviorSubject<BitmapDescriptor>();
  final BehaviorSubject<BitmapDescriptor> allIcon =
      BehaviorSubject<BitmapDescriptor>();
  final BehaviorSubject<List<S.Results>?> addressList$ =
      BehaviorSubject<List<S.Results>?>.seeded([]);

  final BehaviorSubject<Set<Marker>> markerList$ =
      BehaviorSubject<Set<Marker>>();

  final Completer<GoogleMapController> controller = Completer();

  final String? sessionToken = const Uuid().v4();



  CustomInfoWindowController customInfoWindowController =
      CustomInfoWindowController();

  Future<void> initialize() async {
    createMyMarker();
    getCurrentLocation();
  }

  Future<void> searchAddress(String query, PlaceModel myLocation) async {
    if(query.isNotEmpty) {
      var location = await homeRepo.fetchSuggestions(query, myLocation);

      addressList$.sink.add(location);
    }
  }

  Future<int> askLocationPermission() async {
    final status = await PermissionHandlerService()
        .askPermission(BlueBotPermission.LOCATION);
    if (status == BlueBotPermissionStatus.DENIED) {
      return 1;
    } else if (status == BlueBotPermissionStatus.PERMANENTLYDENIED) {
      return 2;
    } else {
      return 0;
    }
  }

  ///Get location coordinates
  Future<void> getCurrentLocation() async {
    emit(BlueBotBaseState.primaryBusy());

    if (await Geolocator.isLocationServiceEnabled()) {
      int permission = await askLocationPermission();
      if (permission == 0) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        try {
          List<geo.Placemark> placeMarks = await geo.placemarkFromCoordinates(
              position.latitude, position.longitude);
          print("placeMarks[0].toString() ${placeMarks[0].toString()}");
          String addressData =
              '${placeMarks[0].street} ${placeMarks[0].subLocality} ${placeMarks[0].locality} ${placeMarks[0].administrativeArea}';
          selectedAddress$.sink.add(PlaceModel(
              address: addressData,
              placeId: placeMarks[0].postalCode!,
              city: placeMarks[0].locality!,
              lat: position.latitude,
              lng: position.longitude));

          emit(BlueBotBaseState.idle());
        } catch (err) {
          debugPrint(err.toString());
          emit(BlueBotBaseState.idle());
          return;
        }
      } else {
        if (permission == 2) {
          showPermissionAllowDialog(
              NavigatorHelper().navigatorKey.currentContext!);
        } else {
          showDialg();
        }
        emit(BlueBotBaseState.idle());

        return;
      }
    } else {
      showEnableDialog(NavigatorHelper().navigatorKey.currentContext!);
      emit(BlueBotBaseState.idle());
      return;
    }
  }

  void showEnableDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) => CustomDialogs.showInfoDialog(
          text: "Can't get current location",
          contentText: 'Please make sure you enable GPS and try again',
          onPressed: () async {
            Navigator.pop(ctx);
            const AndroidIntent intent = AndroidIntent(
                action: 'android.settings.LOCATION_SOURCE_SETTINGS');
            intent.launch().whenComplete(() {});
          }),
    );
  }

  void showPermissionAllowDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext ctx) {
          return WillPopScope(
            child: AlertDialog(
              backgroundColor: APPColors.appWhite,
              title: BlueBotText.subHeaderText(
                text: 'Permission',
                color: APPColors.appBlack,
                fontSize: 4.w,
                fontWeight: FontWeight.bold,
              ),
              content: BlueBotText.subHeaderText(
                text: 'Please allow permission from setting.',
                color: APPColors.appBlack,
                fontSize: 4.w,
              ),
              actions: <Widget>[
                TextButton(
                    child: BlueBotText.subHeaderText(
                      text: 'Exist App',
                      color: APPColors.appBlack,
                      fontSize: 4.w,
                    ),
                    onPressed: () {
                      exit(0);
                    }),
                TextButton(
                    child: BlueBotText.subHeaderText(
                      text: 'Try again',
                      color: APPColors.appBlack,
                      fontSize: 4.w,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx);
                      Navigator.pop(ctx);
                      openAppSettings();
                    })
              ],
            ),
            onWillPop: () async => false,
          );
        });
  }

  createMyMarker() {
    ImageConfiguration configuration =
        const ImageConfiguration(devicePixelRatio: 2.5);
    BitmapDescriptor.fromAssetImage(configuration, 'assets/png/map_marker.png')
        .then((icon) {
      mapIcon.sink.add(icon);
    });
  }

  createAllMarker() {
    ImageConfiguration configuration =
        const ImageConfiguration(devicePixelRatio: 2.5);
    BitmapDescriptor.fromAssetImage(configuration, 'assets/png/all_marker.png')
        .then((icon) {
      allIcon.sink.add(icon);
    });
  }

  Future<Location> resetCurrentLocation() async {
    if (await Geolocator.isLocationServiceEnabled()) {
      int permission = await askLocationPermission();
      if (permission == 0) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        try {
          return Location(position.latitude, position.longitude);
        } catch (err) {
          debugPrint(err.toString());
          return Location(position.latitude, position.longitude);
        }
      } else {
        if (permission == 2) {
          showPermissionAllowDialog(
              globalBloc.mainScreenScaffoldKey.currentContext!);
        } else {
          showDialg();
        }

        return Location(0.0, 0.0);
      }
    } else {
      showEnableDialog(globalBloc.mainScreenScaffoldKey.currentContext!);
      return Location(0.0, 0.0);
    }
  }

  Future<PlaceModel> convertToAddress(PlaceModel? data) async {
    List<geo.Placemark> placeMarks =
        await geo.placemarkFromCoordinates(data!.lat, data.lng);
    debugPrint(placeMarks[0].locality);
    String addressData =
        '${placeMarks[0].street} ${placeMarks[0].subLocality} ${placeMarks[0].locality} ${placeMarks[0].administrativeArea}';
    return PlaceModel(
        address: addressData,
        placeId: placeMarks[0].postalCode!,
        city: placeMarks[0].name!,
        lat: data.lat,
        lng: data.lng);
  }

  void showDialg() {
    showDialog(
        context: NavigatorHelper().navigatorKey.currentContext!,
        barrierDismissible: false,
        useRootNavigator: false,
        builder: (BuildContext ctx) {
          return WillPopScope(
            child: AlertDialog(
              title: const Text("Permission"),
              content: const Text(
                  'Please allow permission to get the company address'),
              actions: <Widget>[
                TextButton(
                    child: const Text('Exist App'),
                    onPressed: () {
                      exit(0);
                    }),
                TextButton(
                    child: const Text('Try again'),
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      getCurrentLocation();
                    })
              ],
            ),
            onWillPop: () async => false,
          );
        });
  }
}
