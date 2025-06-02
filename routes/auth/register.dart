import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import 'package:bunker_online/services/database_service.dart';
import 'package:bunker_online/services/auth_service.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response(
      statusCode: 405,
      body: json.encode({'error': 'Method not allowed'}),
    );
  }

  try {
    // Ініціалізуємо базу даних при першому запиті
    await DatabaseService.instance.initialize();
    
    final body = await context.request.body();
    final data = json.decode(body) as Map<String, dynamic>;

    final email = data['email'] as String?;
    final password = data['password'] as String?;

    if (email == null || password == null || email.isEmpty || password.isEmpty) {
      return Response(
        statusCode: 400,
        body: json.encode({'error': 'Email and password are required'}),
      );
    }

    final authService = AuthService();
    final result = await authService.register(email, password);

    if (result['success'] == true) {
      return Response(
        statusCode: 201,
        body: json.encode(result),
      );
    } else {
      return Response(
        statusCode: 400,
        body: json.encode(result),
      );
    }
  } catch (e) {
    return Response(
      statusCode: 500,
      body: json.encode({'error': 'Internal server error: $e'}),
    );
  }
}