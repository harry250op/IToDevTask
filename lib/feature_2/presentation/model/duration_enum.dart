enum DurationEnum {
  one,
  three,
  five;

  Duration get duration {
    switch (this) {
      case DurationEnum.three:
        return const Duration(seconds: 3);
      case DurationEnum.one:
        return const Duration(seconds: 1);
      case DurationEnum.five:
        return const Duration(seconds: 5);
    }
  }

  String get name {
    switch (this) {
      case DurationEnum.three:
        return '3s';
      case DurationEnum.one:
        return '1s';
      case DurationEnum.five:
        return '5s';
    }
  }
}
