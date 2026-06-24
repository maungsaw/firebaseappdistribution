class WeatherResponse {
  double? latitude;
  double? longitude;
  Current? current;

  WeatherResponse({this.latitude, this.longitude, this.current});

  WeatherResponse.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
    current = json['current'] != null
        ? Current.fromJson(json['current'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    if (current != null) {
      data['current'] = current!.toJson();
    }
    return data;
  }
}

class Current {
  String? time;
  int? interval;
  double? temperature2m;

  Current({this.time, this.interval, this.temperature2m});

  Current.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    interval = json['interval'];
    temperature2m = json['temperature_2m'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['time'] = time;
    data['interval'] = interval;
    data['temperature_2m'] = temperature2m;
    return data;
  }
}
