import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';

/// Screen that shows an example of getDirectoryPath
class GetDirectoryPage extends StatelessWidget {
  void _getDirectoryPath(BuildContext context) async {
    final String initialDirectory = '~/Desktop';
    final String confirmButtonText = 'Choose a cool directory';
    final String directoryPath = await getDirectoryPath(
        initialDirectory: initialDirectory,
        confirmButtonText: confirmButtonText);
    await showDialog(
      context: context,
      builder: (context) => TextDisplay(directoryPath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open a text file"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Press to ask user to choose a directory'),
              onPressed: () => _getDirectoryPath(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays a text file in a dialog
class TextDisplay extends StatelessWidget {
  /// Directory path
  final String directoryPath;

  /// Default Constructor
  TextDisplay(this.directoryPath);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Selected Directory'),
      content: Scrollbar(
        child: SingleChildScrollView(
          child: Text(directoryPath),
        ),
      ),
      actions: [
        FlatButton(
          child: const Text('Close'),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
