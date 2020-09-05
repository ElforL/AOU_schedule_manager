part of widgets;

class AlertsView extends StatelessWidget {
  AlertsView({
    Key key,
    this.alerts,
  }) : super(key: key);
  
  final List<Event> alerts;

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List<Widget>();
    for (var i = 0; i < alerts.length; i++) {
      cards.add(AlertCard(event: alerts[i]));
    }
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
            children: cards,
          )
        ],
      ),
    );
  }
}