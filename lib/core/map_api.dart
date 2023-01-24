// NOTE this file was emptied a lot when I removed Facebook/Google login

import 'dart:io';

import 'package:uuid/uuid.dart';

import '../config/base_source.dart';
import '../domain/entites/SearchResponse.dart';
import '../domain/entites/place_model.dart';

class Suggestion {
  final String placeId;
  final String city;
  final String address;

  Suggestion(this.placeId, this.city, this.address);

  @override
  String toString() {
    return 'Suggestion{placeId: $placeId, city: $city, address: $address}';
  }
}

class PlaceApiProvider extends Source {
  PlaceApiProvider() : super(methodName: '');

  static const String androidKey = 'AIzaSyBCqZDGvAesB_HlSHM4sC5SVUSkn-T3bh0';
  static const String iosKey = 'AIzaSyBCqZDGvAesB_HlSHM4sC5SVUSkn-T3bh0';
  final apiKey = Platform.isAndroid ? androidKey : iosKey;
  String? _sessionToken;

  Future<List<Results>> fetchSuggestions(
      String input, PlaceModel myLocation) async {
    _sessionToken = const Uuid().v4();

    final request =
        'json?query=$input&location=${myLocation.lat},${myLocation.lng}&key=$apiKey';

    final response = await get<SearchResponse>(
        constructUrlWithoutMethodName(request),
        throwOnError: true,
        snackbarOnError: true);

    List<Results> locationList = [];

    print("response!.data.status ${response!.data.status}");
      if (response.data.status == 'OK') {
       return response.data.results!;
      }

    return locationList;
  }
}

//
// https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=ARywPAI7sjRjCJDDonu0zsvvQMFzDEVeBHXxFR2k2TcfDFO2Xg6JciXBNeFo9_nFnAJnaOlnVkZLge3gmLtHc2zoQ7NzJvX6H8TM_PEAKKpXAglX6qdkjUcxICR1GQppowrTXex0whyI8dVO3n7jiWANECKbj2Zh7oAzKfAEme0sh4AaPN1Q&sensor=false&key=AIzaSyBCqZDGvAesB_HlSHM4sC5SVUSkn-T3bh0
