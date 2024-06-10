extension Iterables<E> on Iterable<E> {
  Map<K, List<E>> groupBy<K>(K Function(E) keyFunction) => fold(
      <K, List<E>>{},
      (Map<K, List<E>> map, E element) =>
          map..putIfAbsent(keyFunction(element), () => <E>[]).add(element));

  E? firstWhereOrNull(bool Function(E element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }

  ///Возвращает список, в котором элементы чередуются с [this] и [other].
  //  ///
  //  /// Обе итерации должны иметь одинаковую длину.
  //  ///
  //  /// Пример:
  //  /// ```дротик
  //  /// List<Object> list1 = [1, 2, 3];
  //  /// List<Object> list2 = ['a', 'b', 'c'];
  //  /// list1.alternate(list2); // [1, 'a', 2, 'b', 3, 'c']
  /// ```
  List<E> alternate(Iterable<E> other) {
    if (length != other.length) {
      throw ArgumentError('Обе итерации должны иметь одинаковую длину');
    }

    List<E> result = [];

    for (int i = 0; i < length; i++) {
      result.add(elementAt(i));
      result.add(other.elementAt(i));
    }

    return result;
  }
}
