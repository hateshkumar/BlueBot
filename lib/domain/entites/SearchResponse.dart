class SearchResponse {
  SearchResponse({
    List<dynamic>? htmlAttributions,
    String? nextPageToken,
    List<Results>? results,
    String? status,
  }) {
    _nextPageToken = nextPageToken;
    _results = results;
    _status = status;
  }

  SearchResponse.fromJson(dynamic json) {
    _nextPageToken = json['next_page_token'];
    if (json['results'] != null) {
      _results = [];
      json['results'].forEach((v) {
        _results?.add(Results.fromJson(v));
      });
    }
    _status = json['status'];
  }

  String? _nextPageToken;
  List<Results>? _results;
  String? _status;

  SearchResponse copyWith({
    List<dynamic>? htmlAttributions,
    String? nextPageToken,
    List<Results>? results,
    String? status,
  }) =>
      SearchResponse(
        nextPageToken: nextPageToken ?? _nextPageToken,
        results: results ?? _results,
        status: status ?? _status,
      );

  String? get nextPageToken => _nextPageToken;

  List<Results>? get results => _results;

  String? get status => _status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    map['next_page_token'] = _nextPageToken;
    if (_results != null) {
      map['results'] = _results?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    return map;
  }
}

class Results {
  Results({
    String? businessStatus,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photos>? photos,
    String? placeId,
    PlusCode? plusCode,
    num? rating,
    String? reference,
    List<String>? types,
    num? userRatingsTotal,
  }) {
    _businessStatus = businessStatus;
    _formattedAddress = formattedAddress;
    _geometry = geometry;
    _icon = icon;
    _iconBackgroundColor = iconBackgroundColor;
    _iconMaskBaseUri = iconMaskBaseUri;
    _name = name;
    _openingHours = openingHours;
    _photos = photos;
    _placeId = placeId;
    _plusCode = plusCode;
    _rating = rating;
    _reference = reference;
    _types = types;
    _userRatingsTotal = userRatingsTotal;
  }

  Results.fromJson(dynamic json) {
    _businessStatus = json['business_status'];
    _formattedAddress = json['formatted_address'];
    _geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
    _icon = json['icon'];
    _iconBackgroundColor = json['icon_background_color'];
    _iconMaskBaseUri = json['icon_mask_base_uri'];
    _name = json['name'];
    _openingHours = json['opening_hours'] != null
        ? OpeningHours.fromJson(json['opening_hours'])
        : null;
    if (json['photos'] != null) {
      _photos = [];
      json['photos'].forEach((v) {
        _photos?.add(Photos.fromJson(v));
      });
    }
    _placeId = json['place_id'];
    _plusCode =
        json['plus_code'] != null ? PlusCode.fromJson(json['plus_code']) : null;
    _rating = json['rating'];
    _reference = json['reference'];
    _types = json['types'] != null ? json['types'].cast<String>() : [];
    _userRatingsTotal = json['user_ratings_total'];
  }

  String? _businessStatus;
  String? _formattedAddress;
  Geometry? _geometry;
  String? _icon;
  String? _iconBackgroundColor;
  String? _iconMaskBaseUri;
  String? _name;
  OpeningHours? _openingHours;
  List<Photos>? _photos;
  String? _placeId;
  PlusCode? _plusCode;
  num? _rating;
  String? _reference;
  List<String>? _types;
  num? _userRatingsTotal;

  Results copyWith({
    String? businessStatus,
    String? formattedAddress,
    Geometry? geometry,
    String? icon,
    String? iconBackgroundColor,
    String? iconMaskBaseUri,
    String? name,
    OpeningHours? openingHours,
    List<Photos>? photos,
    String? placeId,
    PlusCode? plusCode,
    num? rating,
    String? reference,
    List<String>? types,
    num? userRatingsTotal,
  }) =>
      Results(
        businessStatus: businessStatus ?? _businessStatus,
        formattedAddress: formattedAddress ?? _formattedAddress,
        geometry: geometry ?? _geometry,
        icon: icon ?? _icon,
        iconBackgroundColor: iconBackgroundColor ?? _iconBackgroundColor,
        iconMaskBaseUri: iconMaskBaseUri ?? _iconMaskBaseUri,
        name: name ?? _name,
        openingHours: openingHours ?? _openingHours,
        photos: photos ?? _photos,
        placeId: placeId ?? _placeId,
        plusCode: plusCode ?? _plusCode,
        rating: rating ?? _rating,
        reference: reference ?? _reference,
        types: types ?? _types,
        userRatingsTotal: userRatingsTotal ?? _userRatingsTotal,
      );

  String? get businessStatus => _businessStatus;

  String? get formattedAddress => _formattedAddress;

  Geometry? get geometry => _geometry;

  String? get icon => _icon;

  String? get iconBackgroundColor => _iconBackgroundColor;

  String? get iconMaskBaseUri => _iconMaskBaseUri;

  String? get name => _name;

  OpeningHours? get openingHours => _openingHours;

  List<Photos>? get photos => _photos;

  String? get placeId => _placeId;

  PlusCode? get plusCode => _plusCode;

  num? get rating => _rating;

  String? get reference => _reference;

  List<String>? get types => _types;

  num? get userRatingsTotal => _userRatingsTotal;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['business_status'] = _businessStatus;
    map['formatted_address'] = _formattedAddress;
    if (_geometry != null) {
      map['geometry'] = _geometry?.toJson();
    }
    map['icon'] = _icon;
    map['icon_background_color'] = _iconBackgroundColor;
    map['icon_mask_base_uri'] = _iconMaskBaseUri;
    map['name'] = _name;
    if (_openingHours != null) {
      map['opening_hours'] = _openingHours?.toJson();
    }
    if (_photos != null) {
      map['photos'] = _photos?.map((v) => v.toJson()).toList();
    }
    map['place_id'] = _placeId;
    if (_plusCode != null) {
      map['plus_code'] = _plusCode?.toJson();
    }
    map['rating'] = _rating;
    map['reference'] = _reference;
    map['types'] = _types;
    map['user_ratings_total'] = _userRatingsTotal;
    return map;
  }
}

class PlusCode {
  PlusCode({
    String? compoundCode,
    String? globalCode,
  }) {
    _compoundCode = compoundCode;
    _globalCode = globalCode;
  }

  PlusCode.fromJson(dynamic json) {
    _compoundCode = json['compound_code'];
    _globalCode = json['global_code'];
  }

  String? _compoundCode;
  String? _globalCode;

  PlusCode copyWith({
    String? compoundCode,
    String? globalCode,
  }) =>
      PlusCode(
        compoundCode: compoundCode ?? _compoundCode,
        globalCode: globalCode ?? _globalCode,
      );

  String? get compoundCode => _compoundCode;

  String? get globalCode => _globalCode;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['compound_code'] = _compoundCode;
    map['global_code'] = _globalCode;
    return map;
  }
}

class Photos {
  Photos({
    num? height,
    List<String>? htmlAttributions,
    String? photoReference,
    num? width,
  }) {
    _height = height;
    _htmlAttributions = htmlAttributions;
    _photoReference = photoReference;
    _width = width;
  }

  Photos.fromJson(dynamic json) {
    _height = json['height'];
    _htmlAttributions = json['html_attributions'] != null
        ? json['html_attributions'].cast<String>()
        : [];
    _photoReference = json['photo_reference'];
    _width = json['width'];
  }

  num? _height;
  List<String>? _htmlAttributions;
  String? _photoReference;
  num? _width;

  Photos copyWith({
    num? height,
    List<String>? htmlAttributions,
    String? photoReference,
    num? width,
  }) =>
      Photos(
        height: height ?? _height,
        htmlAttributions: htmlAttributions ?? _htmlAttributions,
        photoReference: photoReference ?? _photoReference,
        width: width ?? _width,
      );

  num? get height => _height;

  List<String>? get htmlAttributions => _htmlAttributions;

  String? get photoReference => _photoReference;

  num? get width => _width;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['height'] = _height;
    map['html_attributions'] = _htmlAttributions;
    map['photo_reference'] = _photoReference;
    map['width'] = _width;
    return map;
  }

  getPhotoUrl(String reference, String width){
    return  'https://maps.googleapis.com/maps/api/place/photo?maxwidth=$width&photo_reference=$reference&key=AIzaSyBCqZDGvAesB_HlSHM4sC5SVUSkn-T3bh0';
  }
}

class OpeningHours {
  OpeningHours({
    bool? openNow,
  }) {
    _openNow = openNow;
  }

  OpeningHours.fromJson(dynamic json) {
    _openNow = json['open_now'];
  }

  bool? _openNow;

  OpeningHours copyWith({
    bool? openNow,
  }) =>
      OpeningHours(
        openNow: openNow ?? _openNow,
      );

  bool? get openNow => _openNow;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['open_now'] = _openNow;
    return map;
  }
}

class Geometry {
  Geometry({
    Location? location,
    Viewport? viewport,
  }) {
    _location = location;
    _viewport = viewport;
  }

  Geometry.fromJson(dynamic json) {
    _location =
        json['location'] != null ? Location.fromJson(json['location']) : null;
    _viewport =
        json['viewport'] != null ? Viewport.fromJson(json['viewport']) : null;
  }

  Location? _location;
  Viewport? _viewport;

  Geometry copyWith({
    Location? location,
    Viewport? viewport,
  }) =>
      Geometry(
        location: location ?? _location,
        viewport: viewport ?? _viewport,
      );

  Location? get location => _location;

  Viewport? get viewport => _viewport;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_location != null) {
      map['location'] = _location?.toJson();
    }
    if (_viewport != null) {
      map['viewport'] = _viewport?.toJson();
    }
    return map;
  }
}

class Viewport {
  Viewport({
    Northeast? northeast,
    Southwest? southwest,
  }) {
    _northeast = northeast;
    _southwest = southwest;
  }

  Viewport.fromJson(dynamic json) {
    _northeast = json['northeast'] != null
        ? Northeast.fromJson(json['northeast'])
        : null;
    _southwest = json['southwest'] != null
        ? Southwest.fromJson(json['southwest'])
        : null;
  }

  Northeast? _northeast;
  Southwest? _southwest;

  Viewport copyWith({
    Northeast? northeast,
    Southwest? southwest,
  }) =>
      Viewport(
        northeast: northeast ?? _northeast,
        southwest: southwest ?? _southwest,
      );

  Northeast? get northeast => _northeast;

  Southwest? get southwest => _southwest;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_northeast != null) {
      map['northeast'] = _northeast?.toJson();
    }
    if (_southwest != null) {
      map['southwest'] = _southwest?.toJson();
    }
    return map;
  }
}

class Southwest {
  Southwest({
    num? lat,
    num? lng,
  }) {
    _lat = lat;
    _lng = lng;
  }

  Southwest.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }

  num? _lat;
  num? _lng;

  Southwest copyWith({
    num? lat,
    num? lng,
  }) =>
      Southwest(
        lat: lat ?? _lat,
        lng: lng ?? _lng,
      );

  num? get lat => _lat;

  num? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}

class Northeast {
  Northeast({
    num? lat,
    num? lng,
  }) {
    _lat = lat;
    _lng = lng;
  }

  Northeast.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }

  num? _lat;
  num? _lng;

  Northeast copyWith({
    num? lat,
    num? lng,
  }) =>
      Northeast(
        lat: lat ?? _lat,
        lng: lng ?? _lng,
      );

  num? get lat => _lat;

  num? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}

class Location {
  Location({
    num? lat,
    num? lng,
  }) {
    _lat = lat;
    _lng = lng;
  }

  Location.fromJson(dynamic json) {
    _lat = json['lat'];
    _lng = json['lng'];
  }

  num? _lat;
  num? _lng;

  Location copyWith({
    num? lat,
    num? lng,
  }) =>
      Location(
        lat: lat ?? _lat,
        lng: lng ?? _lng,
      );

  num? get lat => _lat;

  num? get lng => _lng;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['lat'] = _lat;
    map['lng'] = _lng;
    return map;
  }
}
