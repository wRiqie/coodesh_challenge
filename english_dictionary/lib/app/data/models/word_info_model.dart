// Model for info requests

class WordInfoModel {
  String word;
  String? phonetic;
  List<Meaning> meanings;

  WordInfoModel({
    required this.word,
    this.phonetic,
    this.meanings = const [],
  });

  factory WordInfoModel.fromApi(Map<String, dynamic> map) {
    return WordInfoModel(
      word: map['word'],
      phonetic: map['phonetic'],
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
