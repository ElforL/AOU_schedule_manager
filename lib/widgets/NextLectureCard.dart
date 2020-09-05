part of widgets;

class NextLectureCard extends StatelessWidget {
  const NextLectureCard({Key key, @required this.status, @required this.lecture}) : super(key: key);

  final int status;
  final Lecture lecture;

  @override
  Widget build(BuildContext context) {

    var cardColor;
    var title;
    var subtitle = '${lecture.courseCode} : ${lecture.room}  ${DateFormat('hh:mm a').format(lecture.startTime)} - ${DateFormat('hh:mm a').format(lecture.endTime)}';

    switch (status) {
      case 0: 
        cardColor = Colors.amber;
        title = 'Next up';
        break;
      case 1: 
        cardColor = Colors.red; 
        title = 'Going on';
        break;
      case 2: 
        cardColor = Colors.blue; 
        title = 'Free';
        subtitle = "We're done for the week";
        break;
      default: throw ArgumentError("NextLectureCard: status can't be other than 0, 1, or 2");
    }

    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20),
      elevation: 2,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18
              ),
            ),
            SizedBox(height: 10),
            Text(
              subtitle
            )
          ],
        ),
      ),
    );
  }
}