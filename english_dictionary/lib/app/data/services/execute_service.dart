import '../models/error_model.dart';
import '../models/default_response_model.dart';

class ExecuteService {
  ExecuteService._();

  static Future<DefaultResponseModel<T>> tryExecuteAsync<T>(
      Future<T?> Function() execute) async {
    try {
      final response = await execute();
      return DefaultResponseModel<T>(data: response);
    } on ErrorModel catch (e) {
      return DefaultResponseModel<T>(error: e);
    }
  }
}
