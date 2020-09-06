part of widgets;

class CourseCard extends StatefulWidget {

  final Course course;
  final UserServices userServices;

  const CourseCard({Key key, this.course, this.userServices}) : super(key: key);

  @override
  _CourseCardState createState() => _CourseCardState();
}

class _CourseCardState extends State<CourseCard> {
  @override
  Widget build(BuildContext context) {
    var radius = BorderRadius.circular(15);
    return Material(
      color: Color(0xFFE7E7E7),
      borderRadius: radius,
      child: InkWell(
        onTap: () async{
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CourseScreen(userServices: widget.userServices,course: widget.course)));
          setState(() {
            
          });
        },
        borderRadius: radius,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(17),
            child: Text(
              widget.course.code,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
      ),
    );
  }
}