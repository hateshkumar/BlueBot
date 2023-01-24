// Necessary because Dart isn't very good with dynamically typed constructors
// https://stackoverflow.com/questions/55237006/how-to-call-a-named-constructor-from-a-generic-function-in-dart-flutter
// ONLY enter those that can be returned from API endpoints




import '../domain/entites/SearchResponse.dart';

final dataFactories = {
  Null: (_) => null,
  SearchResponse: (_) => SearchResponse.fromJson(_),

};
