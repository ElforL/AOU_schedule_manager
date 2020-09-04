part of widgets;

class LectureCard extends StatelessWidget {

  final Lecture lecture;
  final int dayOfMonth;
  
  String startTimeString;
  String endTimeString;

  LectureCard({Key key, @required this.lecture, @required this.dayOfMonth}) : super(key: key){
    final now = new DateTime.now();
    final dtStart = DateTime(now.year, now.month, now.day, lecture.startTime.hour, lecture.startTime.minute);
    final dtEnd = DateTime(now.year, now.month, now.day, lecture.endTime.hour, lecture.endTime.minute);

    startTimeString = DateFormat('hh:mm a').format(dtStart);
    endTimeString = DateFormat('hh:mm a').format(dtEnd);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: kGrayCardColor
        ),

        child: IntrinsicHeight( // Thank you anmol.majhail :)
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // Day & Date
              Material(
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
                        dayOfMonth.toString(), //TODO: try to calculate the day in the card?
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),
                    ),

                    // End
                    Text(
                      endTimeString,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w300
                      ),
                    ),
                  ],
                ),
              ),
              VerticalDivider(color: kOnBackgroundColor, indent: 10, endIndent: 10),

              // Course code and room
              Expanded(
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
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w300
                          ),
                        ),

                        // Room
                        Text(
                          lecture.room,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w300
                          ),
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
}