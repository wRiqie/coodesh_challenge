class FavoriteModel {
  final int? id;
  final String? userId;
  final int? wordId;

  FavoriteModel({
    this.id,
    this.userId,
    this.wordId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'wordId': wordId,
    };
  }

  factory FavoriteModel.fromMap(Map<String, dynamic> map) {
    return FavoriteModel(
      id: map['id'],
      userId: map['userId'],
      wordId: map['wordId'],
    );
  }
}
