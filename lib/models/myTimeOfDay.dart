
class MyTimeOfDay extends DateTime{

  MyTimeOfDay({int hour = 0, int minute = 0}) : super(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
  
  MyTimeOfDay.fromJson(Map<String, dynamic> parsedJson):
    super(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      parsedJson['hour'],
      parsedJson['minute']
    )
  ;

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'hour': hour,
      'minute': minute,
    };
  }
}