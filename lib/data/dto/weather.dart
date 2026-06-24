class WeatherParam {
  final double latitude;
  final double longitude;
  final String current;

  WeatherParam({
    required this.latitude,
    required this.longitude,
    this.current = 'temperature_2m',
  });

  // This method converts the object to a Map for Dio
  Map<String, dynamic> toMap() {
    return {'latitude': latitude, 'longitude': longitude, 'current': current};
  }
}
