import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = new FlutterSecureStorage();

createApiClient() async {
  final token = await storage.read(key: 'access_token');
  print("TOKEN:");
  print(token);
  return Dio(
      BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 5000,
          baseUrl: env['API_URL'],
          headers: {
            "Authorization": "Bearer $token"
          }
      )
  );
}