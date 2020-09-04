part of widgets;

class ScheduleView extends StatelessWidget {
  const ScheduleView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Lectures for this week",
            style: TextStyle(
              color: kOnBackgroundColor,
            ),
          ),
          SizedBox(height: 5),

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LectureCard(dayOfMonth: 23, lecture: Lecture(courseCode: 'TM351', room: 'MC-6', day: 1, repeatType: 1, startTime: TimeOfDay(hour: 8, minute: 00), endTime: TimeOfDay(hour: 10, minute: 00))),
            ],
          )
        ],
      ),
    );
  }
}