abstract class HttpService {
  Future<dynamic> get(
    String path, {
    bool useBaseUrl = true,
    Map<String, dynamic>? queryParams,
  });
}
