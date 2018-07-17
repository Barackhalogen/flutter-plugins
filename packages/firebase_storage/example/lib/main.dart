// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

const String kTestString = 'Hello world!';

void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'test',
    options: new FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:159623150305:ios:4a213ef3dbd8997b'
          : '1:159623150305:android:ef48439a0cc0263d',
      gcmSenderID: '159623150305',
      apiKey: 'AIzaSyChk3KEG7QYrs4kQPLP1tjJNxBTbfCAdgg',
      projectID: 'flutter-firebase-plugins',
    ),
  );
  final FirebaseStorage storage = new FirebaseStorage(
      app: app, storageBucket: 'gs://flutter-firebase-plugins.appspot.com');
  runApp(new MyApp(storage: storage));
}

class MyApp extends StatelessWidget {
  MyApp({this.storage});
  final FirebaseStorage storage;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Storage Example',
      home: new MyHomePage(storage: storage),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.storage});
  final FirebaseStorage storage;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  Map<StorageReference, StorageUploadTask> _files =
      <StorageReference, StorageUploadTask>{};

  Future<Null> _uploadFile() async {
    final String uuid = Uuid().v1();
    final Directory systemTempDir = Directory.systemTemp;
    final File file =
        await new File('${systemTempDir.path}/foo$uuid.txt').create();
    await file.writeAsString(kTestString);
    assert(await file.readAsString() == kTestString);
    final StorageReference ref =
        widget.storage.ref().child('text').child('foo$uuid.txt');
    final StorageUploadTask uploadTask = ref.putFile(
      file,
      new StorageMetadata(
        contentLanguage: 'en',
        customMetadata: <String, String>{'activity': 'test'},
      ),
    );

    setState(() {
      _files[ref] = uploadTask;
    });
  }

  Future<Null> _downloadFile(StorageReference ref, Uri url) async {
    final String uuid = Uuid().v1();
    final http.Response downloadData = await http.get(url);
    final Directory systemTempDir = Directory.systemTemp;
    final File tempFile = new File('${systemTempDir.path}/tmp$uuid.txt');
    if (tempFile.existsSync()) {
      await tempFile.delete();
    }
    await tempFile.create();
    assert(await tempFile.readAsString() == "");
    final StorageFileDownloadTask task = ref.writeToFile(tempFile);
    final int byteCount = (await task.future).totalByteCount;
    final String tempFileContents = await tempFile.readAsString();
    assert(tempFileContents == kTestString);
    assert(byteCount == kTestString.length);

    final String fileContents = downloadData.body;
    final String name = await ref.getName();
    final String bucket = await ref.getBucket();
    final String path = await ref.getPath();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        'Success!\n Downloaded $name \n from bucket: $bucket\n '
            'at path: $path \n\nFile contents: "$fileContents" \n'
            'Wrote "$tempFileContents" to tmp.txt',
        style: const TextStyle(color: const Color.fromARGB(255, 0, 155, 0)),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];
    _files.forEach((StorageReference ref, StorageUploadTask task) {
      final Widget tile = UploadTaskListTile(
        task: task,
        onDismissed: () => setState(() => _files.remove(ref)),
        onDownload: () => _downloadFile(ref, task.lastSnapshot.downloadUrl),
      );
      children.add(tile);
    });
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        title: const Text('Flutter Storage Example'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed:
                _files.isNotEmpty ? () => setState(() => _files.clear()) : null,
          )
        ],
      ),
      body: ListView(
        children: children,
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _uploadFile,
        tooltip: 'Upload',
        child: const Icon(Icons.file_upload),
      ),
    );
  }
}

class UploadTaskListTile extends StatelessWidget {
  const UploadTaskListTile(
      {Key key, this.task, this.onDismissed, this.onDownload})
      : super(key: key);

  final StorageUploadTask task;
  final VoidCallback onDismissed;
  final VoidCallback onDownload;

  String get status {
    String result;
    if (task.isComplete) {
      if (task.isSuccessful) {
        result = 'Complete';
      } else if (task.isCanceled) {
        result = 'Canceled';
      } else {
        result = 'Failed ERROR: ${task.lastSnapshot.error}';
      }
    } else if (task.isInProgress) {
      result = 'Uploading';
    } else if (task.isPaused) {
      result = 'Paused';
    }
    return result;
  }

  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    return '${snapshot.bytesTransferred}/${snapshot.totalByteCount}';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StorageTaskEvent>(
      stream: task.events,
      builder: (BuildContext context,
          AsyncSnapshot<StorageTaskEvent> asyncSnapshot) {
        Widget subtitle;
        if (asyncSnapshot.hasData) {
          final StorageTaskEvent event = asyncSnapshot.data;
          final StorageTaskSnapshot snapshot = event.snapshot;
          subtitle = Text('$status: ${_bytesTransferred(snapshot)} bytes sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return Dismissible(
          key: new Key(task.hashCode.toString()),
          onDismissed: (_) => onDismissed(),
          child: ListTile(
            title: Text('Upload Task #${task.hashCode}'),
            subtitle: subtitle,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Offstage(
                  offstage: !task.isInProgress,
                  child: IconButton(
                    icon: const Icon(Icons.pause),
                    onPressed: () => task.pause(),
                  ),
                ),
                Offstage(
                  offstage: !task.isPaused,
                  child: IconButton(
                    icon: const Icon(Icons.file_upload),
                    onPressed: () => task.resume(),
                  ),
                ),
                Offstage(
                  offstage: task.isComplete,
                  child: IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () => task.cancel(),
                  ),
                ),
                Offstage(
                  offstage: !(task.isComplete && task.isSuccessful),
                  child: IconButton(
                    icon: const Icon(Icons.file_download),
                    onPressed: onDownload,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
