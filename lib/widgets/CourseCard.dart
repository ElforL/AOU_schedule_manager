part of widgets;

class CourseCard extends StatelessWidget {

  final Course course;
  final UserServices userServices;

  const CourseCard({Key key, this.course, this.userServices}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = BorderRadius.circular(15);
    return Material(
      color: Color(0xFFE7E7E7),
      borderRadius: radius,
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => CourseScreen(userServices: userServices,course: course)));
        },
        borderRadius: radius,
        child: Center(
          child: Container(
            padding: EdgeInsets.all(17),
            child: Text(
              course.code,
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