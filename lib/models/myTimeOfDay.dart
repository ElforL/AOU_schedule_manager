
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

  bool operator <(MyTimeOfDay other){
    var today = DateTime.now();
    var first = DateTime(today.year, today.year, today.year, hour, minute);
    var second = DateTime(today.year, today.year, today.year, other.hour, other.minute);
    if(first.difference(second) < Duration.zero){
      return true;
    }
    return false;
  }
}