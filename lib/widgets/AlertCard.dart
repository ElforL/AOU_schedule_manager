part of widgets;

class AlertCard extends StatelessWidget {

  final Event event;
  Color cardColor;
  String title, line1, line2;

  AlertCard({Key key, @required this.event}){
    var diff = event.type == 0?
      event.endDateTime.difference(DateTime.now()).inDays
      :event.startDateTime.difference(DateTime.now()).inDays;
    
    // Colors
    // amber[500]  14 13 12
    // amber[700]  11 10
    // amber[800]  9 8
    // amber[900]  7 6
    //   red[500]  <5

    if(diff > 11){
      cardColor = Colors.amber;
    }else if(diff > 9){
      cardColor = Colors.amber[700];
    }else if(diff > 7){
      cardColor = Colors.amber[800];
    }else if(diff > 5){
      cardColor = Colors.amber[900];
    }else if(diff >= 0){
      cardColor = Colors.red;
    }else{
      throw ArgumentError("event submitted already passed: $diff");
    }

    title = '${event.courseCode} ';
    //0 TMA, 1 MTA, 2 Final
    switch (event.type) {
      case 0: 
        title += 'TMA';
        break;
      case 1: 
        title += 'MTA';
        break;
      default: 
        title += 'Final';
    }

    if(event.remainingTime >= 1440){
      line1 = '${event.remainingTime ~/ 1440} day${event.remainingTime ~/ 1440 != 1?'s':''} remainig';
    }else{
      if(event.remainingTime >= 60){
        line1 = '${event.remainingTime ~/ 60} hour${event.remainingTime ~/ 60 != 1?'s':''} remainig';
      }else{
        line1 = '${event.remainingTime} minute${event.remainingTime != 1?'s':''} remainig';
      }
    }

    line2 = 'Due at ' + DateFormat('dd/MM/yyyy – hh:mm a').format(event.compareDate);
  }

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(20),
        color: cardColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          splashColor: Color(0xffe7e7e7),
          onTap: (){},
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 5),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  line1,
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    // fontSize: 18,
                  ),
                ),
                Text(
                  line2,
                  style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    // fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

