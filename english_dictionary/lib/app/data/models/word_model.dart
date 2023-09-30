// Model for local list
class WordModel {
  final int id;
  final String text;
  bool isFavorited;

  WordModel({
    required this.id,
    required this.text,
    this.isFavorited = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'isFavorited': isFavorited ? 1 : 0,
    };
  }

  factory WordModel.fromMap(Map<String, dynamic> map) {
    return WordModel(
      id: map['id'],
      text: map['text'],
      isFavorited: map['isFavorited'] == 1,
    );
  }
}
