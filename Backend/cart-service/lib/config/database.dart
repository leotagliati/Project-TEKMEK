import 'package:cart_service/config/environment.dart';
import 'package:postgres/postgres.dart';

class Database {
  static Future<Connection> connect() async {
    final conn = await Connection.open(
      Endpoint(
        host: Environment.dbHost,
        database: Environment.dbName,
        username: Environment.dbUser,
        password: Environment.dbPassword,
      ),
      settings: ConnectionSettings(sslMode: SslMode.disable),
    );
    print('Conectado ao PostgreSQL');
    return conn;
  }
}
