class PaginableModel<T> {
  List<T> items;
  int totalItemsCount;

  PaginableModel({
    required this.items,
    required this.totalItemsCount,
  });

  factory PaginableModel.clean() => PaginableModel(
        items: [],
        totalItemsCount: 0,
      );

  factory PaginableModel.fromJson(
      Map<String, dynamic> map, T Function(Map<String, dynamic>) fromJson) {
    return PaginableModel(
      items: map['items'],
      totalItemsCount: map['totalItemsCount'],
    );
  }

  bool isEnd() {
    return items.length >= totalItemsCount;
  }

  int get nextPage => items.length;

  bool get isEmpty => items.isEmpty;

  PaginableModel<T> copyWith({
    List<T>? items,
    int? totalItemsCount,
  }) {
    return PaginableModel<T>(
      items: items ?? this.items,
      totalItemsCount: totalItemsCount ?? this.totalItemsCount,
    );
  }
}
