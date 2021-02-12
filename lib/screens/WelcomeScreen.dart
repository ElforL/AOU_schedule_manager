import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();

  _previoudPage(BuildContext context) async {
    if (_controller.page == 0) {
      Navigator.pop(context);
    } else {
      await _controller.previousPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
    }
  }

  _nextPage(BuildContext context) async {
    if (_controller.page == 3) {
      Navigator.pop(context);
    } else {
      await _controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
    }
  }

  String _getLeftBtnText() {
    if (_controller.hasClients) {
      if (_controller.page != 0) return 'Previous';
    }
    return 'Skip';
  }

  String _getRightBtnText() {
    if (_controller.hasClients) {
      if (_controller.page != 3) return 'Next';
    }
    return 'Done';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.hasClients && _controller.page % 1 == 0) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _controller,
              children: [
                View(
                  image: AssetImage('assets/2.png'),
                  text: MarkdownBody(
                    data: "When you press the `Add Courses` button it'll take you to the _courses list_ screen.\n" +
                        "1. Here, you first set the semester start date. It's important to determine the week numbers for even/odd lectures.\n" +
                        "2. Then to add a new course press on the `+` button at the bottom.",
                  ),
                ),
                View(
                  image: AssetImage('assets/4.png'),
                  text: MarkdownBody(
                    data: "This is the _course edit screen_ where you can:\n" +
                        "1. Edit the courses code in the top field.\n" +
                        "2. Add a lecture using the `ADD LECTURE` button.\n" +
                        "3. Add an _event_ using the `ADD EVENT` button. This could be a TMA, MTA, Final, Quiz, etc...\n" +
                        "4. Delete the course using the bottom button.",
                  ),
                ),
                View(
                  image: AssetImage('assets/6.png'),
                  text: MarkdownBody(
                    data: "This is the _home screen_. It shows:\n" +
                        "1. The next lecture.\n" +
                        "2. Alerts: shows alerts for close _events_.\n" +
                        "3. The remaining lectures in the week.",
                  ),
                ),
                View(
                  image: AssetImage('assets/7.png'),
                  text: MarkdownBody(
                    data: "The next lecture card has 4 modes:\n" +
                        "1. Coming up lecture.\n" +
                        "2. Coming up lecture **today** (has a darker color).\n" +
                        "3. Going on.\n" +
                        "4. Free: when all lectures in the week are done",
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FlatButton.icon(
                    label: Text(_getLeftBtnText()),
                    icon: Icon(Icons.navigate_before_rounded),
                    onPressed: () {
                      _previoudPage(context);
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton.icon(
                    label: Icon(Icons.navigate_next_rounded),
                    icon: Text(_getRightBtnText()),
                    onPressed: () {
                      _nextPage(context);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class View extends StatelessWidget {
  const View({Key key, @required this.image, @required this.text}) : super(key: key);

  final ImageProvider image;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 450),
            margin: EdgeInsets.all(50),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
            ),
            child: Image(
              image: image,
            ),
          ),
          Expanded(
            child: SingleChildScrollView(child: text),
          ),
        ],
      ),
    );
  }
}
