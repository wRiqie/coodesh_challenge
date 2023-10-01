class HistoryModel {
  final String id;
  final int wordId;
  final String userId;
  final DateTime displayDate;

  HistoryModel({
    this.id = '',
    required this.wordId,
    required this.userId,
    required this.displayDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': '$userId$wordId',
      'wordId': wordId,
      'userId': userId,
      'displayDate': displayDate.millisecondsSinceEpoch,
    };
  }

  factory HistoryModel.fromMap(Map<String, dynamic> map) {
    return HistoryModel(
      id: map['id'],
      wordId: map['wordId'],
      userId: map['userId'],
      displayDate: DateTime.fromMillisecondsSinceEpoch(map['displayDate']),
    );
  }
}
