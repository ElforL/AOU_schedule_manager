import 'package:flutter/material.dart';
import 'package:uni_assistant/services/UserServices.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SisWebScreen extends StatefulWidget {
  final UserServices userServices;
  final String regFormUrl;

  SisWebScreen({Key key, @required this.userServices, this.regFormUrl}) : super(key: key);

  @override
  _SisWebScreenState createState() => _SisWebScreenState();
}

class _SisWebScreenState extends State<SisWebScreen> {
  static const _sisUrl = 'https://sisksa.aou.edu.kw/OnlineServices/';

  WebViewController _webController;
  int _progress = 100;

  @override
  void initState() {
    super.initState();
    // waiting 1 sec to avoid error:
    // dependOnInheritedWidgetOfExactType<_LocalizationsScope>() or dependOnInheritedElement() was called before _SisScreenState.initState() completed.
    Future.delayed(Duration(seconds: 1)).then((value) => showInitDialog());
  }

  showInitDialog() {
    var alert = AlertDialog(
      title: Text('Configuring SIS'),
      content: Text(
          'Check the webview in this page. and confirm that the registeration form is loaded\nIf it\'s not press the SIS button on top of the webview and navigate to the registeration form then press confirm.'),
      actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text('OK'))],
    );
    showDialog(context: context, builder: (context) => alert);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SIS Configuration'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Webview controls
            Container(
              height: 50,
              color: Colors.black38,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      _webController.goBack();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed: () {
                      _webController.goForward();
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () {
                      _webController.reload();
                    },
                  ),
                  IconButton(
                    icon: Text('SIS'),
                    onPressed: () {
                      _webController.loadUrl(_sisUrl);
                    },
                  ),
                  Expanded(
                    child: Text(
                      'Webview controls',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            // Web view
            LinearProgressIndicator(
              value: _progress / 100,
            ),
            Container(
              height: 550,
              child: WebView(
                onWebViewCreated: (c) => _webController = c,
                javascriptMode: JavascriptMode.unrestricted,
                onProgress: (p) {
                  setState(() {
                    _progress = p;
                  });
                },
                initialUrl: widget.regFormUrl ?? _sisUrl,
              ),
            ),
            ElevatedButton(
              child: Text('CONFIRM'),
              onPressed: () async {
                widget.userServices.sisUrl = await _webController.currentUrl();
                Navigator.of(context).popUntil(ModalRoute.withName('SisScreen'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
