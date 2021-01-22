part of widgets;

class NextLectureCard extends StatelessWidget {
  const NextLectureCard({Key key, @required this.lecture}) : super(key: key);

  final Lecture lecture;

  @override
  Widget build(BuildContext context) {
    var cardColor;
    var title;
    var subtitle;
    var status = lecture == null ? 2 : lecture.getStatus(DateTime.now());

    if (status == 2) {
      cardColor = Colors.blue;
      title = 'Free';
      subtitle = "We're done for the week";
    } else {
      subtitle =
          '${lecture.courseCode} : ${lecture.getDayName()} ${lecture.room} ${lecture.startTime.toString()} - ${lecture.endTime.toString()}';
      switch (status) {
        case 0:
          if (lecture.day == UserServices.getWeekday(DateTime.now()))
            cardColor = Colors.amber[800];
          else
            cardColor = Colors.amber;
          title = 'Next up';
          break;
        case 1:
          cardColor = Colors.red;
          title = 'Going on';
          break;
      }
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12),
            )
          ],
        ),
      ),
    );
  }
}
