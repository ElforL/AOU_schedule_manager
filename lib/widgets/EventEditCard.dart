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
  DateTime timeVal;

  @override
  Widget build(BuildContext context) {
    descVal = widget.event.description;
    timeVal = widget.event.time;

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
                      widget.parent.widget.course.events.remove(widget.event);
                    });
                  },
                ),
              )
            ],
          ),

          // Title
          TextField(
            controller: TextEditingController(text: widget.event.title),
            decoration: InputDecoration(
              labelText: 'TITLE',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
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
              if (value.length <= 10) widget.event.title = value;
            },
          ),

          SizedBox(height: 10),

          // Desc
          TextField(
            controller: TextEditingController(text: widget.event.description),
            decoration: InputDecoration(
              labelText: 'DESCRIPTION',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w500,
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
                      controller: TextEditingController(text: '${DateFormat('dd/MM/yyyy').format(widget.event.time)}'),
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
                      onTap: () async {
                        widget.event.time = await _selectDate(context, widget.event.time);
                        setState(() {});
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
                      controller: TextEditingController(
                        text: DateFormat('hh:mm a').format(widget.event.time),
                      ),
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
                          initialTime: TimeOfDay.fromDateTime(widget.event.time),
                        );
                        if (newTime != null) {
                          setState(() {
                            var old = widget.event.time;
                            widget.event.time = DateTime(
                              old.year,
                              old.month,
                              old.day,
                              newTime.hour,
                              newTime.minute,
                            );
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),

              Expanded(flex: 2, child: Container()),
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
