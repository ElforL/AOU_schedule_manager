part of widgets;

// ignore: must_be_immutable
class LectureCard extends StatelessWidget {
  final Lecture lecture;
  final int type;

  String startTimeString;
  String endTimeString;
  LectureCard({Key key, @required this.lecture, this.type}) : super(key: key) {
    startTimeString = DateFormat('hh:mm a').format(lecture.startTime);
    endTimeString = DateFormat('hh:mm a').format(lecture.endTime);
  }

  @override
  Widget build(BuildContext context) {
    var subBlueString = type == 0 ? getDate() : getRepeatString();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        color: kGrayCardColor,
        child: IntrinsicHeight(
          // Thank you anmol.majhail :)
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Day & Date
              Expanded(
                flex: 1,
                child: Material(
                  elevation: 3,
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(15),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 13, horizontal: 11),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Day
                        Text(
                          lecture.getDayShortcut(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // Date
                        Text(
                          subBlueString,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: type == 0 ? 15 : 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Time
              Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Start
                    Text(
                      startTimeString,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                    ),

                    // End
                    Text(
                      endTimeString,
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ),
              VerticalDivider(color: kOnBackgroundColor, indent: 10, endIndent: 10),

              // Course code and room
              Expanded(
                flex: 3,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Code
                        Text(
                          lecture.courseCode,
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w300),
                        ),

                        // Room
                        Text(
                          lecture.room,
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String getDate() {
    var today = DateTime.now();
    var tmp = today;

    for (var i = 1; UserServices.getWeekday(tmp) != lecture.day; i++) {
      tmp = DateTime(today.year, today.month, today.day + i);
    }

    return tmp.day.toString();
  }

  String getRepeatString() {
    switch (lecture.repeatType) {
      case 0:
        return 'WEEKLY';
      case 1:
        return 'ODD';
      default:
        return 'EVEN';
    }
  }
}
