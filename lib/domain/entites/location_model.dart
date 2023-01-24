class Location{

  double _lat;
  double _long;

  Location(this._lat, this._long);

  double get long => _long;

  set long(double value) {
    _long = value;
  }

  double get lat => _lat;

  set lat(double value) {
    _lat = value;
  }
}