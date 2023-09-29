// Model for info requests

class WordInfoModel {
  String word;
  String phonetic;

  WordInfoModel({
    required this.word,
    required this.phonetic,
  });

  factory WordInfoModel.fromApi(Map<String, dynamic> map) {
    return WordInfoModel(
      word: map['word'],
      phonetic: map['phonetic'],
    );
  }
}
