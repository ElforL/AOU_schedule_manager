part of widgets;

class ScheduleView extends StatelessWidget {
  const ScheduleView({
    Key key,
    this.lectures,
  }) : super(key: key);

  final List<Lecture> lectures;

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = new List();
    for (var i = 0; i < lectures.length; i++) {
      cards.add(LectureCard(dayOfMonth: 22, lecture: lectures[i]));
    }
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
            children: cards,
          )
        ],
      ),
    );
  }
}