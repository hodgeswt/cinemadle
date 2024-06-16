class With {
  static List<T> listCopyWith<T>(List<T>? list, T element) {
    return List<T>.from(list ?? []).prepend(element);
  }

  static Map<K, V> mapCopyWith<K, V>(Map<K, V>? map, K key, V value) {
    return Map<K, V>.from(map ?? {}).withData(key, value);
  }
}

extension Prepend<T> on List<T> {
  List<T> prepend(T element) {
    return [element, ...this];
  }
}

extension WithData<K, V> on Map<K, V> {
  Map<K, V> withData(K key, V value) {
    putIfAbsent(key, () => value);
    return this;
  }
}

extension Union<T> on List<T> {
  List<T> union(List<T> other) {
    return where((element) => other.contains(element)).toList();
  }
}

extension GetOrDefault<T> on List<T> {
  T getOrDefault(int index, T defaultValue) {
    return index < length ? this[index] : defaultValue;
  }
}

extension Equals<T> on List<T> {
  bool equals(List<T> other) {
    return length == other.length &&
        every((element) => other.contains(element));
  }
}

extension UniformPadding on String {
  String uniformPadding(int length) {
    int l = (this.length - length).abs();
    if (l == 0) {
      return this;
    }

    String left = ' ' * (l / 2).floor();
    String right = ' ' * (l / 2).ceil();

    return '$left$this$right';
  }
}

extension MaxLength on List<String> {
  int maxLength() {
    return fold(
        0,
        (int previousValue, element) =>
            element.length > previousValue ? element.length : previousValue);
  }
}

extension UniformPaddingList on List<String> {
  List<String> uniformPadding() {
    int l = maxLength();
    return map((e) => e.uniformPadding(l)).toList();
  }
}
