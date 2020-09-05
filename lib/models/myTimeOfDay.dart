
class MyTimeOfDay extends DateTime{

  MyTimeOfDay({int hour = 0, int minute = 0}) : super(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
  
}