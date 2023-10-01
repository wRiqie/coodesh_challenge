import 'dart:ffi';

import 'package:english_dictionary/app/core/helpers/json_helper.dart';
import 'package:english_dictionary/app/data/data_sources/word/word_data_source.dart';
import 'package:english_dictionary/app/data/data_sources/word/word_data_source_local_db_imp.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:english_dictionary/app/data/services/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class LocalDbServiceMock extends Mock implements LocalDbService {}

class JsonHelperMock extends Mock implements JsonHelper {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  group('WordDataSourceLocalDbImp Tests', () {
    late LocalDbServiceMock localDbServiceMock;
    late JsonHelper jsonHelperMock;
    late WordDataSource wordDataSource;

    setUp(() {
      localDbServiceMock = LocalDbServiceMock();
      jsonHelperMock = JsonHelperMock();
      wordDataSource = WordDataSourceLocalDbImp(
        localDbServiceMock,
        jsonHelperMock,
      );
    });

    test('getWords should return PaginableModel<WordModel>', () async {
      const query = 'word';
      const limit = 10;
      const offset = 0;
      const userId = 'user123';

      final paginableModel =
          PaginableModel<WordModel>(items: [], totalItemsCount: 0);

      when(() =>
              localDbServiceMock.getWords(query, limit, offset, false, userId))
          .thenAnswer((_) async => paginableModel);

      final result =
          await wordDataSource.getWords(query, limit, offset, userId);

      expect(result, equals(paginableModel));
    });

    test('downloadWords should download and save words', () async {
      final jsonData = ['word1', 'word2', 'word3'];

      when(() => jsonHelperMock.getData(any())).thenAnswer((_) => jsonData);
      when(() => localDbServiceMock.saveAllWords(any()))
          .thenAnswer((_) => Future(() => Void));

      await wordDataSource.downloadWords();

      verify(() => localDbServiceMock.saveAllWords(jsonData)).called(1);
    });
  });
}
