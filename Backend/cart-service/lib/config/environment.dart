import 'package:dotenv/dotenv.dart';

class Environment {
  static final DotEnv _env = DotEnv(includePlatformEnvironment: true)..load();

  static String get dbHost => _env['DB_HOST'] ?? 'localhost';
  static String get dbName => _env['DB_NAME'] ?? 'products_db';
  static String get dbUser => _env['DB_USER'] ?? 'postgres';
  static String get dbPassword => _env['DB_PASSWORD'] ?? '';
  static String get eventBusUrl =>
      _env['EVENT_BUS_URL'] ?? 'http://localhost:5300/event';
}
