part of widgets;

class LectureEditCard extends StatefulWidget {
  final Lecture lecture;
  final CourseEditScreenState parent;

  LectureEditCard({
    Key key,
    this.lecture,
    this.parent,
  }) : super(key: key);

  @override
  _LectureEditCardState createState() => _LectureEditCardState();
}

class _LectureEditCardState extends State<LectureEditCard> {
  int dayVal;
  RepeatType repeatVal;
  MyTimeOfDay startVal;
  MyTimeOfDay endVal;
  String roomVal;

  @override
  Widget build(BuildContext context) {
    dayVal = widget.lecture.day;
    repeatVal = widget.lecture.repeatType;
    startVal = widget.lecture.startTime;
    endVal = widget.lecture.endTime;
    roomVal = widget.lecture.room;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFFe7e7e7),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.red,
                ),
                child: IconButton(
                  color: Colors.white,
                  iconSize: 10,
                  padding: EdgeInsets.all(0),
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    widget.parent.setState(() {
                      widget.parent.widget.course.lectures.remove(widget.lecture);
                    });
                  },
                ),
              )
            ],
          ),

          ////// Day and Repeat
          Row(
            children: [
              // Day
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'DAY',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 12,
                      ),
                    ),
                    DropdownButton<int>(

                        /// Colors
                        // Underline
                        underline: Container(
                          height: 1.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF828282),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        // Icon and text
                        iconEnabledColor: Color(0xFF828282),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        dropdownColor: Color(0xffe7e7e7),

                        /// Values
                        value: dayVal,
                        elevation: 1,
                        onChanged: (int newVal) {
                          setState(() {
                            dayVal = newVal;
                            widget.lecture.day = newVal;
                          });
                        },
                        items: List<DropdownMenuItem<int>>.generate(6, (index) {
                          return DropdownMenuItem<int>(
                            value: (index + 1),
                            child: Text(widget.lecture.getDayName(index + 1)),
                          );
                        })),
                  ],
                ),
              ),

              SizedBox(width: 30),

              // Repeat
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'REPEAT',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 12,
                      ),
                    ),
                    DropdownButton<RepeatType>(
                        isExpanded: true,

                        /// Colors
                        // Underline
                        underline: Container(
                          height: 1.0,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFF828282),
                                width: 1,
                              ),
                            ),
                          ),
                        ),
                        // Icon and text
                        iconEnabledColor: Color(0xFF828282),
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                        dropdownColor: Color(0xffe7e7e7),

                        /// Values
                        value: repeatVal,
                        elevation: 1,
                        onChanged: (RepeatType newVal) {
                          setState(() {
                            repeatVal = newVal;
                            widget.lecture.repeatType = newVal;
                          });
                        },
                        items: [
                          DropdownMenuItem<RepeatType>(
                            value: (RepeatType.weekly),
                            child: Text('Weekly'),
                          ),
                          DropdownMenuItem<RepeatType>(
                            value: (RepeatType.odd),
                            child: Text('Odd'),
                          ),
                          DropdownMenuItem<RepeatType>(
                            value: (RepeatType.even),
                            child: Text('Even'),
                          ),
                        ]),
                  ],
                ),
              ),

              Expanded(child: Container()),
            ],
          ),

          SizedBox(height: 20),

          // Start and end times
          Row(
            children: [
              // Start
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'START TIME',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(text: widget.lecture.startTime.toString()),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color(0xFF828282),
                        ),
                        counterStyle: TextStyle(color: Color(0xff828282)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF828282)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF828282)),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF828282)),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      onTap: () async {
                        var newTime = await showTimePicker(
                          context: context,
                          initialTime: widget.lecture.startTime,
                        );
                        if (newTime != null) {
                          setState(() {
                            var timeCompare = MyTimeOfDay.compare(newTime, widget.lecture.endTime);
                            if (timeCompare == 1 || timeCompare == 0) {
                              widget.lecture.endTime = MyTimeOfDay(hour: newTime.hour + 2, minute: newTime.minute);
                            }
                            widget.lecture.startTime = MyTimeOfDay(hour: newTime.hour, minute: newTime.minute);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              SizedBox(width: 30),

              // End
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'END TIME',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 12,
                      ),
                    ),
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(text: widget.lecture.endTime.toString()),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: Color(0xFF828282),
                        ),
                        counterStyle: TextStyle(color: Color(0xff828282)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF828282)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF828282)),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF828282)),
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      onTap: () async {
                        var newTime = await showTimePicker(
                          context: context,
                          initialTime: widget.lecture.endTime,
                        );
                        if (newTime != null) {
                          setState(() {
                            widget.lecture.endTime = MyTimeOfDay(hour: newTime.hour, minute: newTime.minute);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              Expanded(child: Container())
            ],
          ),

          // Room
          TextField(
            controller: TextEditingController(text: widget.lecture.room),
            decoration: InputDecoration(
              labelText: 'ROOM',
              labelStyle: TextStyle(
                color: Color(0xFF828282),
              ),
              counterStyle: TextStyle(color: Color(0xff828282)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF828282)),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF828282)),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF828282)),
              ),
            ),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            maxLength: 10,
            onChanged: (value) {
              widget.lecture.room = value;
            },
          ),
        ],
      ),
    );
  }
}
