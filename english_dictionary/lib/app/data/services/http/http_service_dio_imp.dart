import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';

import '../../../core/constants.dart';
import '../../adapters/dio_error_adapter.dart';
import 'http_service.dart';

class HttpServiceDioImp implements HttpService {
  Dio _dio({
    bool useBaseUrl = true,
    Duration? connectTimeout,
    Duration? receiveTimeout,
    ResponseType? responseType,
    Map<String, dynamic>? headers,
    String? contentType,
  }) {
    final dio = Dio(BaseOptions(
      baseUrl: useBaseUrl ? Constants.baseUrl : '',
      connectTimeout: connectTimeout ?? const Duration(seconds: 10),
      receiveTimeout: receiveTimeout ?? const Duration(seconds: 10),
      responseType: responseType,
      headers: headers,
      contentType: contentType,
    ));

    if (kDebugMode) {
      (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
          (dioClient) {
        dioClient.badCertificateCallback = (cert, host, port) => true;
        return dioClient;
      };
    }

    _setInterceptors(dio);
    return dio;
  }

  @override
  Future get(String path,
      {bool useBaseUrl = true, Map<String, dynamic>? queryParams}) async {
    try {
      final response = await _dio(useBaseUrl: useBaseUrl)
          .get(path, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      throw DioErrorAdapter.convertToErrorModel(e);
    }
  }

  void _setInterceptors(Dio dio) {
    final interceptors = InterceptorsWrapper(
      onRequest: (request, handler) {
        handler.next(request);
      },
      onError: (e, handler) {
        if (kDebugMode) {
          print(e);
        }
        handler.reject(e);
      },
    );

    dio.interceptors.add(interceptors);
  }
}
