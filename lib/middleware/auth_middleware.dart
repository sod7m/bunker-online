import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

Middleware authMiddleware() {
  return (handler) {
    return (context) async {
      final authorization = context.request.headers['authorization'];
      
      if (authorization == null || !authorization.startsWith('Bearer ')) {
        return Response(
          statusCode: 401,
          body: json.encode({'error': 'Authorization token required'}),
        );
      }

      try {
        final token = authorization.substring(7); // Remove 'Bearer '
        final env = DotEnv()..load();
        
        final jwt = JWT.verify(token, SecretKey(env['JWT_SECRET']!));
        final userId = jwt.payload['user_id'] as int;
        
        // Додаємо userId до контексту
        final updatedContext = context.provide<int>(() => userId);
        return handler(updatedContext);
      } catch (e) {
        return Response(
          statusCode: 401,
          body: json.encode({'error': 'Invalid token'}),
        );
      }
    };
  };
}