import 'package:english_dictionary/app/data/data_sources/auth/auth_data_source.dart';
import 'package:english_dictionary/app/data/data_sources/auth/auth_data_source_firebase_imp.dart';
import 'package:english_dictionary/app/data/data_sources/favorite/favorite_data_source.dart';
import 'package:english_dictionary/app/data/data_sources/favorite/favorite_data_source_local_db_imp.dart';
import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/data_sources/word/word_data_source_local_db_imp.dart';
import 'package:english_dictionary/app/data/data_sources/word_info/word_info_data_source.dart';
import 'package:english_dictionary/app/data/data_sources/word_info/word_info_data_source_api_imp.dart';
import 'package:english_dictionary/app/data/repositories/auth_repository.dart';
import 'package:english_dictionary/app/data/repositories/favorite_repository.dart';
import 'package:english_dictionary/app/data/repositories/word_info_repository.dart';
import 'package:english_dictionary/app/data/repositories/word_repository.dart';
import 'package:english_dictionary/app/data/services/local_db_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    getIt.registerLazySingleton<LocalDbService>(() => LocalDbService());

    // Datasources
    getIt.registerLazySingleton<AuthDataSource>(
        () => AuthDataSourceFirebaseImp(FirebaseAuth.instance));
    getIt.registerLazySingleton<WordDataSource>(
        () => WordDataSourceLocalDbImp(getIt(), getIt()));
    getIt.registerLazySingleton<WordInfoDataSource>(
        () => WordInfoDataSourceApiImp(getIt()));
    getIt.registerLazySingleton<FavoriteDataSource>(
        () => FavoriteDataSourceLocalDbImp(getIt()));

    // Repositories
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt()));
    getIt.registerLazySingleton<WordRepository>(() => WordRepository(getIt()));
    getIt.registerLazySingleton<WordInfoRepository>(
        () => WordInfoRepository(getIt()));
    getIt.registerLazySingleton<FavoriteRepository>(
        () => FavoriteRepository(getIt()));
  }
}
