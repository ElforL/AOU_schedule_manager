part of widgets;

class EventCard extends StatelessWidget {
  final Event event;

  const EventCard({Key key, this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kGrayCardColor,
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Type
            Expanded(
              flex: 1,
              child: Material(
                elevation: 3,
                color: Colors.green,
                borderRadius: BorderRadius.circular(15),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    height: 35,
                    child: Center(
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Text(
                            event.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (event.description.isNotEmpty)
                      FittedBox(
                        child: Text(
                          event.description.isNotEmpty ? event.description : ' ',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Text(
                      DateFormat('dd/MM/yyyy hh:mm a').format(event.time),
                      style: TextStyle(color: Colors.white, fontSize: event.description.isNotEmpty ? 10 : 13),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
