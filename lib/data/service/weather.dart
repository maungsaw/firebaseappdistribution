import 'package:firebaseappdistribution/core/core.dart'
    show ClientEndPoint, BaseNetworkService;
import 'package:firebaseappdistribution/data/data.dart'
    show WeatherServiceImp, WeatherParam, WeatherResponse;

class WeatherService extends BaseNetworkService<WeatherResponse>
    implements WeatherServiceImp {
  WeatherService() : super(ClientEndPoint.weather);

  @override
  Future<WeatherResponse?> fetchAll(WeatherParam param) async =>
      await getByParam(param.toMap());

  @override
  Future<void> fetch() async => await getById('');

  @override
  WeatherResponse fromJson(Map<String, dynamic> json) =>
      WeatherResponse.fromJson(json);
}
