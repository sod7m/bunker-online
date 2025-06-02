import 'package:bcrypt/bcrypt.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';
import 'package:postgres/postgres.dart';
import 'package:bunker_online/models/user.dart';
import 'package:bunker_online/services/database_service.dart';

class AuthService {
  final DatabaseService _db = DatabaseService.instance;

  Future<Map<String, dynamic>> register(String email, String password) async {
    try {
      // Перевірка чи користувач вже існує
      final existingUser = await _getUserByEmail(email);
      if (existingUser != null) {
        return {'success': false, 'message': 'User already exists'};
      }

      // Хешування пароля
      final hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

      // Створення користувача з правильним синтаксисом для PostgreSQL
      final result = await _db.connection.execute(
        Sql.named(
          'INSERT INTO users (email, password_hash) VALUES (@email, @password_hash) RETURNING id, email, created_at, updated_at'
        ),
        parameters: {
          'email': email,
          'password_hash': hashedPassword,
        },
      );

      if (result.isNotEmpty) {
        final userData = result.first.toColumnMap();
        final token = _generateJWT(userData['id'] as int);
        
        return {
          'success': true,
          'token': token,
          'user': {
            'id': userData['id'],
            'email': userData['email'],
            'created_at': userData['created_at'].toString(),
          }
        };
      }

      return {'success': false, 'message': 'Failed to create user'};
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final user = await _getUserByEmail(email);
      if (user == null) {
        return {'success': false, 'message': 'User not found'};
      }

      // Перевірка пароля
      if (!BCrypt.checkpw(password, user['password_hash'] as String)) {
        return {'success': false, 'message': 'Invalid password'};
      }

      final token = _generateJWT(user['id'] as int);
      
      return {
        'success': true,
        'token': token,
        'user': {
          'id': user['id'],
          'email': user['email'],
          'created_at': user['created_at'].toString(),
        }
      };
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  Future<Map<String, dynamic>?> _getUserByEmail(String email) async {
    final result = await _db.connection.execute(
      Sql.named('SELECT * FROM users WHERE email = @email'),
      parameters: {'email': email},
    );

    return result.isNotEmpty ? result.first.toColumnMap() : null;
  }

  String _generateJWT(int userId) {
    final env = DotEnv()..load();
    final jwt = JWT({
      'user_id': userId,
      'exp': DateTime.now().add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
    });

    return jwt.sign(SecretKey(env['JWT_SECRET']!));
  }
}