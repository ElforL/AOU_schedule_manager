class Event {
  //0 TMA, 1 MTA, 2 Final
  final int type;
  final String courseCode;
  String included;
  DateTime startDateTime;
  DateTime endDateTime;

  Event(this.type, this.courseCode, this.included, this.startDateTime, this.endDateTime){
    if(type > 2 || type < 0) throw ArgumentError('Event type must be 0, 1, or 2');
    if(included.length > 46) throw ArgumentError('Event "included" can\'t be more than 46 characters long');
  }

  
}