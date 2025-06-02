import 'dart:io';
import 'package:postgres/postgres.dart';
import 'package:dotenv/dotenv.dart';

class DatabaseService {
  static DatabaseService? _instance;
  late Connection _connection;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<void> initialize() async {
    final env = DotEnv()..load();
    
    _connection = await Connection.open(
      Endpoint(
        host: env['DATABASE_HOST']!,
        port: int.parse(env['DATABASE_PORT']!),
        database: env['DATABASE_NAME']!,
        username: env['DATABASE_USER']!,
        password: env['DATABASE_PASSWORD']!,
      ),
      settings: const ConnectionSettings(
        sslMode: SslMode.require,
      ),
    );

    await _createTables();
  }

  Future<void> _createTables() async {
    await _connection.execute(
      Sql.named('''
        CREATE TABLE IF NOT EXISTS users (
          id SERIAL PRIMARY KEY,
          email VARCHAR(255) UNIQUE NOT NULL,
          password_hash VARCHAR(255) NOT NULL,
          created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )
      ''')
    );
  }

  Connection get connection => _connection;

  Future<void> close() async {
    await _connection.close();
  }
}