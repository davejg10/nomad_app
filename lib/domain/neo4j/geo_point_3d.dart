class GeoPoint3D {
  final double _latitude;
  final double _longitude;
  final double _height;

  GeoPoint3D(this._latitude, this._longitude, this._height);

  double get getLatitude => _latitude;

  double get getLongitude => _longitude;

  double get getHeight => _height;

  @override
  String toString() {
    return 'GeoPoint3D{_latitude: $_latitude, _longitude: $_longitude, _height: $_height}';
  }
}