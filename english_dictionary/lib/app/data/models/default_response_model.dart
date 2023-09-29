import 'error_model.dart';

// Para requisições externas
class DefaultResponseModel<T> {
  final T? data;
  final ErrorModel? error;

  DefaultResponseModel({
    this.data,
    this.error,
  });

  bool get isSuccess => error == null;
}
