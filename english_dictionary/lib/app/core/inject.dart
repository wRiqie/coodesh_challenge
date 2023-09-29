import 'package:get_it/get_it.dart';
import '../data/services/http/http_service.dart';
import '../data/services/http/http_service_dio_imp.dart';
import '../data/stores/session_store.dart';
import 'helpers/dialog_helper.dart';
import 'helpers/preferences_helper.dart';
import 'helpers/session_helper.dart';

class Inject {
  Inject._();

  static void init() {
    final getIt = GetIt.I;

    // Stores
    getIt.registerLazySingleton<SessionStore>(() => SessionStore());

    // Helpers
    getIt.registerLazySingleton<DialogHelper>(() => DialogHelper());
    getIt.registerLazySingleton<PreferencesHelper>(() => PreferencesHelper());
    getIt.registerLazySingleton<SessionHelper>(
        () => SessionHelper(getIt(), getIt()));

    // Data Services
    getIt.registerLazySingleton<HttpService>(() => HttpServiceDioImp());

    // Datasources

    // Repositories
  }
}
