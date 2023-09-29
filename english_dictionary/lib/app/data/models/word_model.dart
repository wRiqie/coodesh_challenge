class WordModel {
  String word;
  String phonetic;

  WordModel({
    required this.word,
    required this.phonetic,
  });

  factory WordModel.fromApi(Map<String, dynamic> map) {
    return WordModel(
      word: map['word'],
      phonetic: map['phonetic'],
    );
  }
}
