
abstract class BlueBotEnum<T> {
  final T value;

  const BlueBotEnum(this.value);

  @override
  bool operator ==(dynamic other) {
    if (other is BlueBotEnum<T>) {
      return value == other.value;
    } else {
      return false;
    }
  }

  @override
  int get hashCode => value.hashCode;
}
