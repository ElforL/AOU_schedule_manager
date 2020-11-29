class MyTimeOfDay extends DateTime {
  MyTimeOfDay({int hour = 0, int minute = 0}) : super(1, 1, 1, hour, minute);

  MyTimeOfDay.fromJson(Map<String, dynamic> parsedJson)
      : super(
          1,
          1,
          1,
          parsedJson['hour'],
          parsedJson['minute'],
        );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'hour': hour,
      'minute': minute,
    };
  }

  bool operator <(MyTimeOfDay other) {
    return this.difference(other) < Duration.zero;
  }
}
