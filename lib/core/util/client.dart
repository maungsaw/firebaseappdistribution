abstract class ApiClient {
  static String baseUrl = 'http://10.10.1.99:5132';
  static String clientVersion = '/api';
  static String prefix = '';
}

abstract class ClientEndPoint {
  static String weather = '/weather';
  static String auth = '/auth';
  /// Relative segments (no leading slash) — joined via [joinPath].
  static String login = 'login';
  static String devicesRegister = 'devices-register';
  static String refresh = '/auth/refresh';

  static String joinPath(String base, String segment) {
    final left = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final right = segment.startsWith('/') ? segment.substring(1) : segment;
    return '$left/$right';
  }
} 
