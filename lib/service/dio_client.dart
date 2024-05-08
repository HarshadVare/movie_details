import 'package:dio/dio.dart';

class DioClient {
  DioClient._internal();

  static final _singleton = DioClient._internal();

  factory DioClient() => _singleton;

  static Dio createDio() {
    return Dio();
  }

  static final dio = createDio();
}
