import 'package:dio/dio.dart';
import 'api-constant.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      queryParameters: {
        "apikey": ApiConstants.apiKey,
      },
    ),
  );
}
