import 'package:dart_frog/dart_frog.dart';
import 'package:bunker_online/services/database_service.dart';

Future<Response> onRequest(RequestContext context) async {
  try {
    // Тестуємо підключення до бази
    await DatabaseService.instance.initialize();
    
    return Response(
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Cache-Control': 'no-cache',
      },
      body: '''
Welcome to Bunker Online API!

Available endpoints:
- POST /auth/register - Register new user
- POST /auth/login - Login user

Database connection: ✅ Connected to DigitalOcean PostgreSQL
      ''',
    );
  } catch (e) {
    return Response(
      statusCode: 500,
      headers: {
        'Content-Type': 'text/plain; charset=utf-8',
        'Cache-Control': 'no-cache',
      },
      body: '''
Welcome to Bunker Online API!

Database connection: ❌ Error: $e
      ''',
    );
  }
}
