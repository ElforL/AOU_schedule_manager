import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_assistant/services/UserServices.dart';

class ImportExportScreen extends StatelessWidget {
  final UserServices userServices;

  const ImportExportScreen({Key key, @required this.userServices}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Import or export your data'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Text(
                "This page allows you to import/export your data on the app.",
                textAlign: TextAlign.center,
              ),
              Text(
                "This is useful if you are changing or resetting your phone",
                textAlign: TextAlign.center,
              ),
              Text(
                "However, if not careful you may ruin the saved data.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.red),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      child: Text('IMPORT'),
                      onPressed: () {
                        _nextPage(context, true);
                      },
                    ),
                    ElevatedButton(
                      child: Text('EXPORT'),
                      onPressed: () async {
                        _nextPage(context, false);
                        await Clipboard.setData(ClipboardData(text: await userServices.readFile()));
                        await Future.delayed(Duration(milliseconds: 500));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("JSON data copied to clipboard.")),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _nextPage(BuildContext context, bool isImport) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _FinalImportExportScreen(
          userServices: userServices,
          isImport: isImport,
        ),
      ),
    );
  }
}

class _FinalImportExportScreen extends StatelessWidget {
  final bool isImport;
  final UserServices userServices;
  final _tfContoller = TextEditingController();

  _FinalImportExportScreen({Key key, this.isImport, @required this.userServices}) : super(key: key) {
    if (!isImport) userServices.readFile().then((value) => _tfContoller.text = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isImport ? 'Import' : 'Export'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(_getText()),
                ),
                Container(
                  color: Colors.black38,
                  child: TextField(
                    controller: _tfContoller,
                    minLines: 3,
                    maxLines: 20,
                    readOnly: !isImport,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                if (isImport)
                  ElevatedButton(
                    child: Text('IMPORT'),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      var res = _import();
                      if (res) {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).build(context);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            res ? 'Import successful.' : "Failed to import. Data couldn't be parsed.",
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _import() {
    var newJson = _tfContoller.text.trim();

    // try to decode the json to check if it throws any errors
    try {
      jsonDecode(newJson);
    } catch (e) {
      return false;
    }

    userServices.writeToFile(newJson);
    userServices.loadUser();
    return true;
  }

  String _getText() {
    if (isImport) {
      return 'Paste the JSON string in the text field below:';
    } else {
      return 'Below is your data in JSON format:';
    }
  }
}
