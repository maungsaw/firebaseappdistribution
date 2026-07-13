abstract class ApiClient {
  static String baseUrl = 'http://10.10.1.63:5132';
  static String clientVersion = '/api';
  static String prefix = '';
}

abstract class ClientEndPoint {
  static String weather = '/weather';
  static String login = '/auth/login';
  static String devicesRegister = '/auth/devices-register';
  static String refresh = '/auth/refresh';
}
