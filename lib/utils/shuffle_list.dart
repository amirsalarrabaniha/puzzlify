import 'dart:math';

extension ListExtensions<T> on List<T> {
  List<T> deranged() {
    final random = Random();
    List<T> result = List.from(this);

    for (int i = 0; i < result.length; i++) {
      int j = i;
      while (j == i) {
        j = random.nextInt(result.length);
      }
      T temp = result[i];
      result[i] = result[j];
      result[j] = temp;
    }

    for (int i = 0; i < result.length; i++) {
      if (result[i] == this[i]) {
        return deranged();
      }
    }

    return result;
  }

  void swap(int first, int second) {
    final temp = this[first];
    this[first] = this[second];
    this[second] = temp;
  }
}
