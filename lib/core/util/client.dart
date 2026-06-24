abstract class ApiClient {
  static String baseUrl = 'https://api.open-meteo.com';
  static String clientVersion = '/v1';
  static String prefix = '';
}

abstract class ClientEndPoint {
  static String weather = '/forecast';
}
