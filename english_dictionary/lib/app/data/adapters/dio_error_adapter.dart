import 'package:dio/dio.dart';
import '../models/error_model.dart';

class DioErrorAdapter {
  DioErrorAdapter._();

  static ErrorModel convertToErrorModel(DioException error) {
    return ErrorModel.fromApi(error);
  }
}
