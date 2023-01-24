import '../../core/map_api.dart';
import '../entites/SearchResponse.dart';
import '../entites/place_model.dart';
import 'base_repository.dart';

class HomeRepository extends BaseRepository {
  final PlaceApiProvider _placeApiProvider = PlaceApiProvider();

  Future<List<Results>> fetchSuggestions(
      String input, PlaceModel myLocation) async {
    var locationList = _placeApiProvider.fetchSuggestions(input, myLocation);

    return locationList;
  }
}
