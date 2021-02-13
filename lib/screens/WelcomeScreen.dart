import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _controller = PageController();

  static final _views = [
    View(
      isBordered: false,
      image: AssetImage('assets/uni_launcher.png'),
      text: Text(
        "Welcome to AOU Schedule Manager.\n" +
            "This app will help you track your lectures, Quizzes, TMAs, MTAs, and Finals.\n" +
            "\n\n Press Next or swipe left, to see how it works.",
        textAlign: TextAlign.center,
      ),
    ),
    View(
      image: AssetImage('assets/2.png'),
      text: MarkdownBody(
        data: "First, you will need to add your courses in the courses list page  \n" +
            "You can navigate to it by pressing the `Add Courses` button at the start page, or using the drawer.\n" +
            "1. Once there, you first set the semester start date. It's important to determine the week numbers for even/odd lectures.\n" +
            "2. Then add a new course by pressing the `+` button at the bottom.",
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
  ];

  _previoudPage(BuildContext context) async {
    if (_controller.page == 0) {
      Navigator.pop(context);
    } else {
      await _controller.previousPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
    }
  }

  _nextPage(BuildContext context) async {
    if (_controller.page == _views.length - 1) {
      Navigator.pop(context);
    } else {
      await _controller.nextPage(duration: Duration(milliseconds: 200), curve: Curves.bounceIn);
    }
  }

  String _getLeftBtnText() {
    if (_controller.hasClients) {
      if (_controller.page != 0) return 'PREVIOUS';
    }
    return 'SKIP';
  }

  String _getRightBtnText() {
    if (_controller.hasClients) {
      if (_controller.page == _views.length - 1) return 'DONE';
    }
    return 'NEXT';
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
              children: _views,
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: FlatButton.icon(
                    label: Text(_getLeftBtnText()),
                    icon: Icon(
                      _getLeftBtnText() == 'PREVIOUS' ? Icons.navigate_before_rounded : Icons.skip_previous,
                    ),
                    onPressed: () {
                      _previoudPage(context);
                    },
                  ),
                ),
                Expanded(
                  child: FlatButton.icon(
                    label: Icon(
                      _getRightBtnText() == 'NEXT' ? Icons.navigate_next_rounded : Icons.done,
                    ),
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
  const View({Key key, @required this.image, @required this.text, this.isBordered = true}) : super(key: key);

  final ImageProvider image;
  final Widget text;
  final bool isBordered;

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
              border: isBordered ? Border.all(color: Colors.white) : null,
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
