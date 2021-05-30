import 'package:flutter/material.dart';
import 'package:uni_assistant/screens/SisWebScreen.dart';
import 'package:uni_assistant/services/SisServices.dart';
import 'package:uni_assistant/services/UserServices.dart';

class SisConfigScreen extends StatefulWidget {
  final UserServices userServices;
  final SisServices sisServices;

  SisConfigScreen({Key key, @required this.userServices, @required this.sisServices}) : super(key: key);

  @override
  _SisConfigScreenState createState() => _SisConfigScreenState();
}

class _SisConfigScreenState extends State<SisConfigScreen> {
  var _tfController = TextEditingController();

  @override
  void dispose() {
    _tfController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (widget.userServices.sisUrl != null) _tfController.text = widget.userServices.sisUrl;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIS Configuration'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Here you can configure the app to automatically check the SIS for any updates on your courses.'),
              SizedBox(height: 20),
              Text('To set it up, you need to provide the url of the registeration form from SIS.'),
              Text(
                'To get to it\n1- login to your SIS account\n2- Press on "Go to the Financial section"\n3- Press on "Print Registration Form"',
              ),
              Text(
                'Make sure you press on "Print Registration Form" (in english) and not "طباعة الجدول الدراسي"',
                style: TextStyle(color: Colors.red),
              ),
              Text('You should see something like this:'),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Image.asset('assets/reg_form.png'),
              ),
              Text('4- Now, copy the url of the webpage and paste it in the text field below'),
              TextField(
                controller: _tfController,
                decoration: InputDecoration(hintText: 'Paste the URL here'),
              ),
              SizedBox(height: 50),
              Row(
                children: [
                  ElevatedButton(
                    child: Text('OK'),
                    onPressed: () {
                      _okBtn();
                    },
                  ),
                  if (widget.userServices.sisUrl != null) SizedBox(width: 50),
                  if (widget.userServices.sisUrl != null)
                    ElevatedButton(
                      child: Text('REMOVE SIS'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      onPressed: () {
                        _showRemoveDialog();
                      },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showRemoveDialog() async {
    var dialog = AlertDialog(
      title: Text('Remove SIS'),
      content: Text('Are you sure you want to remove SIS?'),
      actions: [
        TextButton(
          child: Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text('REMOVE'),
          onPressed: () {
            widget.sisServices.removeSisConfig();
            Navigator.of(context).popUntil(ModalRoute.withName('SisScreen'));
          },
        ),
      ],
    );
    await showDialog(context: context, builder: (_) => dialog);
    setState(() {});
  }

  _okBtn() {
    if (_tfController.text.trim().isNotEmpty) {
      try {
        var uri = Uri.parse(_tfController.text.trim());
        if (uri.host + uri.path != 'sisksa.aou.edu.kw/SISReports/Report.aspx') {
          _showSnackBar('Invalid URL. URL must starts with sisksa.aou.edu.kw/SISReports/Report.aspx');
        } else {
          widget.userServices.sisUrl = null;
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SisWebScreen(
                userServices: widget.userServices,
                regFormUrl: _tfController.text.trim(),
              ),
            ),
          );
        }
      } catch (e) {
        _showSnackBar('You must enter the a valid URL');
      }
    } else {
      _showSnackBar('You must enter the url first');
    }
  }

  _showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}
