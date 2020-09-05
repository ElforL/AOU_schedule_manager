class Event {
  //0 TMA, 1 MTA, 2 Final
  final int _type;
  final String _courseCode;
  String _description;
  DateTime _startDateTime;
  DateTime _endDateTime;

  Event(this._type, this._courseCode, this._description, this._startDateTime, this._endDateTime){
    if(type > 2 || type < 0) throw ArgumentError('Event type must be 0, 1, or 2');
    if(description.length > 46) throw ArgumentError('Event "included" can\'t be more than 46 characters long');
  }

  Event.fromJson(Map<String, dynamic> parsedJson):
    _type = parsedJson['type'],
    _courseCode = parsedJson['courseCode'],
    _description = parsedJson['description'],
    _startDateTime = DateTime(parsedJson['startDateTime']['year'],
                              parsedJson['startDateTime']['month'],
                              parsedJson['startDateTime']['day'],
                              parsedJson['startDateTime']['hour'],
                              parsedJson['startDateTime']['minute']
    ),
    _endDateTime = DateTime(parsedJson['endDateTime']['year'],
                            parsedJson['endDateTime']['month'],
                            parsedJson['endDateTime']['day'],
                            parsedJson['endDateTime']['hour'],
                            parsedJson['endDateTime']['minute']
  );

  Map<String, dynamic> toJson(){
    return <String, dynamic>{
      'type': type,
      'courseCode': courseCode,
      'description': description,
      'startDateTime': {
        'year': startDateTime.year,
        'month': startDateTime.month,
        'day': startDateTime.day,
        'hour': startDateTime.hour,
        'minute': startDateTime.minute,
      },
      'endDateTime': {
        'year': endDateTime.year,
        'month': endDateTime.month,
        'day': endDateTime.day,
        'hour': endDateTime.hour,
        'minute': endDateTime.minute,
      },
    };
  }

  int get type{
    return _type;
  }
  String get courseCode{
    return _courseCode;
  }
  String get description{
    return _description;
  }
  DateTime get startDateTime{
    return _startDateTime;
  }
  DateTime get endDateTime{
    return _endDateTime;
  }

  set description(String newDesc){
    _description = newDesc;
  }
  set startDateTime(DateTime newStart){
    _startDateTime = newStart;
  }
  set endDateTime(DateTime newEnd){
    _endDateTime = newEnd;
  }

  // get remainingDays{
  //   DateTime today = DateTime.now();
  //   DateTime todayFixed = DateTime(today.year, today.month, today.day);
  //   return compareDate.difference(todayFixed).inDays;
  // }

  get remainingTime{
    DateTime today = DateTime.now();
    DateTime todayFixed = DateTime(today.year, today.month, today.day);
    if(compareDate.difference(todayFixed).inDays > 0){
      return compareDate.difference(todayFixed).inMinutes;
    }else{
      return compareDate.difference(today).inMinutes;
    }
  }

  DateTime get compareDate{
    if(type == 0) 
      return endDateTime;
    else
      return startDateTime;
  }
}