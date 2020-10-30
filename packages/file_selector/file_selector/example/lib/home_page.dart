import 'package:flutter/material.dart';

/// Home Page of the application
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Selector Demo Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Open a text file'),
              onPressed: () => Navigator.pushNamed(context, '/open/text'),
            ),
            SizedBox(height: 10),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Open an image'),
              onPressed: () => Navigator.pushNamed(context, '/open/image'),
            ),
            SizedBox(height: 10),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Open multiple images'),
              onPressed: () => Navigator.pushNamed(context, '/open/images'),
            ),
            SizedBox(height: 10),
            RaisedButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: Text('Save text into a file'),
              onPressed: () => Navigator.pushNamed(context, '/save/text'),
            ),
          ],
        ),
      ),
    );
  }
}
