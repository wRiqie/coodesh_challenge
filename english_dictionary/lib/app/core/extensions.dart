import 'package:flutter/material.dart';

extension MediaQueryExt on MediaQueryData {
  double get width => size.width;
  double get height => size.height;
}

extension ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
