part of widgets;

class AlertsView extends StatelessWidget {
  const AlertsView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Alerts",
            style: TextStyle(
              color: kOnBackgroundColor,
            ),
          ),
          SizedBox(height: 6),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AlertCard(event: Event(0,'TM112', 'Included Text', DateTime(2019, 5, 12), DateTime(2020,9,22,21,30))),
              AlertCard(event: Event(2,'TM111', 'Included Text', DateTime(2020, 12, 12), DateTime(2020,9,22,21,30))),
            ],
          )
        ],
      ),
    );
  }
}