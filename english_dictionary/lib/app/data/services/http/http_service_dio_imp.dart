import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

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

    dio.interceptors.add(_generateCacheConfig());
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

  DioCacheInterceptor _generateCacheConfig() {
    final options = CacheOptions(
      store: MemCacheStore(),
      maxStale: const Duration(minutes: 30),
    );
    return DioCacheInterceptor(options: options);
  }
}
