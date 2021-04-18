import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Dio createDio() {
  return Dio(
      BaseOptions(
          connectTimeout: 5000,
          receiveTimeout: 5000,
          baseUrl: env['BASE_URL']
      )
  );
}