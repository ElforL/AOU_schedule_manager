part of widgets;

// ignore: must_be_immutable
class AlertCard extends StatelessWidget {
  static const _textStyle = TextStyle(color: Colors.black);
  final Event event;
  Color cardColor;
  String title, line1, line2;

  AlertCard({Key key, @required this.event});

  @override
  Widget build(BuildContext context) {
    var diff = event.time.difference(DateTime.now()).inDays;

    // Colors
    // amber[500]  14 13 12
    // amber[700]  11 10
    // amber[800]  9 8
    // amber[900]  7 6
    //   red[500]  <5

    if (diff > 11) {
      cardColor = Colors.amber;
    } else if (diff > 9) {
      cardColor = Colors.amber[700];
    } else if (diff > 7) {
      cardColor = Colors.amber[800];
    } else if (diff > 5) {
      cardColor = Colors.amber[900];
    } else if (diff >= 0) {
      cardColor = Colors.red;
    } else {
      throw ArgumentError("event submitted already passed: $diff");
    }

    title = '${event.course.code}: ${event.title}';

    if (event.remainingTime >= 1440) {
      line1 = '${event.remainingTime ~/ 1440} day${event.remainingTime ~/ 1440 != 1 ? 's' : ''} remainig';
    } else {
      if (event.remainingTime >= 60) {
        line1 = '${event.remainingTime ~/ 60} hour${event.remainingTime ~/ 60 != 1 ? 's' : ''} remainig';
      } else {
        line1 = '${event.remainingTime} minute${event.remainingTime != 1 ? 's' : ''} remainig';
      }
    }

    line2 = 'at ' + DateFormat('dd/MM/yyyy – hh:mm a').format(event.time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        color: cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Color(0xffe7e7e7),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CourseScreen(course: event.course)));
          },
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  line1,
                  style: _textStyle,
                ),
                Text(
                  line2,
                  style: _textStyle,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
