import '../../core/extensions.dart';

// Model for info requests
class WordInfoModel {
  String word;
  String? phonetic;
  String? audioUrl;
  List<Meaning> meanings;

  WordInfoModel({
    required this.word,
    this.phonetic,
    this.audioUrl,
    this.meanings = const [],
  });

  factory WordInfoModel.fromApi(Map<String, dynamic> map) {
    var phonetics = map['phonetics'] as List;
    String? audio;
    if (phonetics.isNotEmpty) {
      var value = phonetics.firstWhereOrNull(
          (e) => e['audio'] != null && e['audio'] != "")?['audio'];
      audio = value;
    }

    return WordInfoModel(
      word: map['word'],
      phonetic: map['phonetic'],
      audioUrl: audio,
      meanings:
          List<Meaning>.from(map['meanings']?.map((e) => Meaning.fromMap(e))),
    );
  }
}

class Meaning {
  final String? partOfSpeech;
  final List<Definition> definitions;

  Meaning({
    this.partOfSpeech,
    this.definitions = const [],
  });

  factory Meaning.fromMap(Map<String, dynamic> map) {
    return Meaning(
      partOfSpeech: map['partOfSpeech'],
      definitions: List<Definition>.from(map['definitions']?.map(
        (e) => Definition.fromMap(e),
      )),
    );
  }
}

class Definition {
  final String? text;

  Definition({
    this.text,
  });

  factory Definition.fromMap(Map<String, dynamic> map) {
    return Definition(
      text: map['definition'],
    );
  }
}
