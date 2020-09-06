part of widgets;

class EventEditCard extends StatefulWidget {

  final Event event;
  final CourseEditScreenState parent;

  const EventEditCard({Key key, this.event, this.parent}) : super(key: key);

  @override
  _EventEditCardState createState() => _EventEditCardState();
}

class _EventEditCardState extends State<EventEditCard> {

  int typeVal;
  String descVal;
  DateTime startVal;
  DateTime endVal;

  @override
  Widget build(BuildContext context) {
    typeVal = widget.event.type;
    descVal = widget.event.description;
    startVal = widget.event.startDateTime;
    endVal = widget.event.endDateTime;

    List<int> available = widget.parent.widget.course.nextEventsList() + [typeVal];


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
                  onPressed: (){
                    widget.parent.setState(() {
                      widget.parent.widget.course.events.remove(widget.event);
                    });
                  },
                ),
              )
            ],
          ),

          // TYPE
          Row(
            children: [

              // Day
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('TYPE',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                    DropdownButton<int>(
                      /// Colors
                      // Underline
                      isExpanded: true,
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
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                      dropdownColor: Color(0xffe7e7e7),

                      /// Values
                      value: typeVal,
                      elevation: 1,
                      onChanged: (int newVal) {
                        setState(() {
                          typeVal = newVal;
                          widget.event.type = newVal;
                        });
                        widget.parent.setState(() {
                          
                        });
                      },
                      items: available.map((e) {
                        return DropdownMenuItem(
                          value: e,
                          child: Text(Event.getTypeName(e))
                        );
                      }).toList()
                    ),
                  ],
                ),
              ),
              SizedBox(width: 30),
              Expanded(flex: 2, child: Container()),
              Expanded(child: Container()),
            ],
          ),

          SizedBox(height: 10),

          // Desc
          TextField(
            controller: TextEditingController(
              text: widget.event.description
            ),
            decoration: InputDecoration(
              labelText: 'DESCRIPTION',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF828282),
              ),
              counterStyle: TextStyle(
                color: Color(0xff828282)
              ),
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
            maxLength: 45,
            onChanged: (value) {
              widget.event.description = value;
            },
          ),

          // Date
          Row(
            children: [

              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      readOnly: true,
                      controller: TextEditingController(
                        text: '${DateFormat('dd/MM/yyyy').format(widget.event.type == 0? widget.event.endDateTime: widget.event.startDateTime)}'
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        labelText: 'DATE',
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF828282),
                        ),
                        counterStyle: TextStyle(
                          color: Color(0xff828282)
                        ),
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
                      onTap: () async{
                        if(widget.event.type != 0)
                          widget.event.startDateTime = await _selectDate(context, widget.event.startDateTime);
                        else
                          widget.event.endDateTime = await _selectDate(context, widget.event.endDateTime);
                        setState(() {
                        });
                      },
                    )
                  ],
                ),
              ),
              Expanded(flex: 2, child: Container()),
            ],
          ),
          
          SizedBox(height: 10),

          Row(
            children: [

              // Start
              widget.event.type == 0? SizedBox()
              :Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('START TIME',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 12,
                      ),
                    ),
                    DropdownButton<DateTime>(
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
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                      dropdownColor: Color(0xffe7e7e7),

                      /// Values
                      value: startVal,
                      elevation: 1,
                      onChanged: (DateTime newVal) {
                        setState(() {
                          startVal = newVal;
                          widget.event.startDateTime = newVal;
                        });
                      },
                      items: List<DropdownMenuItem<DateTime>>.generate(96, (index) {
                        var time = DateTime(
                          widget.event.startDateTime.year,
                          widget.event.startDateTime.month,
                          widget.event.startDateTime.day,
                          0+ index~/4,
                          15*(index % 4)
                        );
                        if(widget.event.startDateTime != time)
                          return DropdownMenuItem<DateTime>(
                            value: time,
                            child: Text('${DateFormat('hh:mm a').format(time)}'),
                          );
                        else
                          return DropdownMenuItem<DateTime>(
                            value: time.add(Duration(minutes: 5)),
                            child: Text('${DateFormat('hh:mm a').format(time)}'),
                          );
                      })
                      +[
                        DropdownMenuItem<DateTime>(
                          value: widget.event.startDateTime,
                          child: Text('${DateFormat('hh:mm a').format(widget.event.startDateTime)}'),
                        )
                      ]
                    ),
                  ],
                ),
              ),

              SizedBox(width: widget.event.type != 0? 30: 0),
              
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('END TIME',
                      style: TextStyle(
                        color: Color(0xFF828282),
                        fontSize: 12,
                      ),
                    ),
                    DropdownButton<DateTime>(
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
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold
                      ),
                      dropdownColor: Color(0xffe7e7e7),

                      /// Values
                      value: endVal,
                      elevation: 1,
                      onChanged: (DateTime newVal) {
                        setState(() {
                          endVal = newVal;
                          widget.event.endDateTime = newVal;
                        });
                      },
                      items: List<DropdownMenuItem<DateTime>>.generate(96, (index) {
                        var time = DateTime(
                          widget.event.endDateTime.year,
                          widget.event.endDateTime.month,
                          widget.event.endDateTime.day,
                          index~/4,
                          15*(index % 4)
                        );
                        if(time != widget.event.endDateTime)
                          return DropdownMenuItem<DateTime>(
                            value: time,
                            child: Text('${DateFormat('hh:mm a').format(time)}'),
                          );
                        else
                          return DropdownMenuItem<DateTime>(
                            value: time.add(Duration(minutes: 5)),
                            child: Text('${DateFormat('hh:mm a').format(time)}'),
                          );
                      })
                      +[
                        DropdownMenuItem<DateTime>(
                          value: widget.event.endDateTime,
                          child: Text('${DateFormat('hh:mm a').format(widget.event.endDateTime)}'),
                        )
                      ]
                    ),
                  ],
                ),
              ),

              Expanded(flex: widget.event.type == 0? 2: 1, child: Container())
            ],
          ),         
        ],
      ),
    );
  }

  Future<DateTime> _selectDate(BuildContext context, DateTime selectedDate) async {
    var picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(selectedDate.year - 9),
      lastDate: DateTime(selectedDate.year + 9),
    );
    if (picked != null && picked != selectedDate)
      return picked;
    else
      return selectedDate;
  }
}