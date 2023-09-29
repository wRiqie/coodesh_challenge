// Model for local list

class WordModel {
  final int id;
  final String text;
  WordModel({
    required this.id,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': 0,
      'text': text,
    };
  }

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'],
      text: map['text'],
    );
  }
}
