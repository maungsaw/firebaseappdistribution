abstract class ApiClient {
  static String baseUrl = 'http://10.10.1.63:5132';
  static String clientVersion = '/api';
  static String prefix = '';
}

abstract class ClientEndPoint {
  static String weather = '/weather';
  static String auth = '/auth';
  static String login = '/login';
  static String devicesRegister = '/devices-register';
  static String refresh = '/refresh';
}
