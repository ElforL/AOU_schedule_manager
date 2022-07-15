part of widgets;

class DurationDialoig extends StatefulWidget {
  final int currentVal;

  const DurationDialoig({Key key, this.currentVal}) : super(key: key);

  @override
  _DurationDialoigState createState() => _DurationDialoigState(currentVal);
}

class _DurationDialoigState extends State<DurationDialoig> {
  _DurationDialoigState(this.currentVal);

  int currentVal;

  Widget okButton() => TextButton(
        child: Text("OK"),
        onPressed: () {
          Navigator.pop(context, currentVal);
        },
      );

  Widget cancelButton() => TextButton(
        child: Text("CANCEL"),
        onPressed: () => Navigator.pop(context),
      );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Choose a new value'),
      actions: [cancelButton(), okButton()],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 6; i++)
            RadioListTile(
              title: Text('${10 * i} minutes'),
              value: 10 * i,
              groupValue: currentVal,
              onChanged: (newVal) {
                setState(() {
                  currentVal = newVal;
                });
              },
            ),
        ],
      ),
    );
  }
}
