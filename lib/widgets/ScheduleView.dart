part of widgets;

class ScheduleView extends StatelessWidget {
  const ScheduleView({
    Key key,
    this.lectures,
    this.forNextWeek,
  }) : super(key: key);

  final List<Lecture> lectures;
  final bool forNextWeek;

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = new List();
    for (var i = 0; i < lectures.length; i++) {
      cards.add(LectureCard(type: 0, lecture: lectures[i]));
    }

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Lectures for ${forNextWeek ? 'next' : 'this'} week",
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
