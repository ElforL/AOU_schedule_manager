part of widgets;

class ListLabel extends StatelessWidget {
  const ListLabel({
    Key key,
    @required this.text,
    this.color,
  }) : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          letterSpacing: 1,
        ),
      ),
    );
  }
}
