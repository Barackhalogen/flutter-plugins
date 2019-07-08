// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

Future<void> main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db2',
    options: Platform.isIOS
        ? const FirebaseOptions(
            googleAppID: '1:297855924061:ios:c6de2b69b03a5be8',
            gcmSenderID: '297855924061',
            databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
          )
        : const FirebaseOptions(
            googleAppID: '1:297855924061:android:669871c998cc21bd',
            apiKey: 'AIzaSyD_shO5mfO9lhy2TVWhfo1VUmARKlG4suk',
            databaseURL: 'https://flutterfire-cd2f7.firebaseio.com',
          ),
  );
  runApp(MaterialApp(
    title: 'Flutter Database Example',
    home: MyHomePage(app: app),
  ));
}

class MyHomePage extends StatefulWidget {
  MyHomePage({this.app});
  final FirebaseApp app;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter;
  DatabaseReference _counterRef;
  DatabaseReference _messagesRef;
  StreamSubscription<Event> _counterSubscription;
  StreamSubscription<Event> _messagesSubscription;
  bool _anchorToBottom = false;

  String _kTestKey = 'Hello';
  String _kTestValue = 'world!';
  DatabaseError _error;

  @override
  void initState() {
    super.initState();
    print('connecting');
    _counterRef = FirebaseDatabase.instance.reference().child('counter');
    FirebaseDatabase.instance.reference().once().then((DataSnapshot snapshot) {
      print('Connected to database and read ${snapshot.value}');
    });
  }

  @override
  void dispose() {
    super.dispose();
//    _messagesSubscription.cancel();
//    _counterSubscription.cancel();
  }

  Future<void> _increment() async {
    // Increment counter in transaction.
    final TransactionResult transactionResult =
        await _counterRef.runTransaction((MutableData mutableData) async {
      mutableData.value = (mutableData.value ?? 0) + 1;
      return mutableData;
    });

    if (transactionResult.committed) {
      _messagesRef.push().set(<String, String>{
        _kTestKey: '$_kTestValue ${transactionResult.dataSnapshot.value}'
      });
    } else {
      print('Transaction not committed.');
      if (transactionResult.error != null) {
        print(transactionResult.error.message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Database Example'),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: Center(
              child: _error == null
                  ? Text(
                      'Button tapped $_counter time${_counter == 1 ? '' : 's'}.\n\n'
                      'This includes all devices, ever.',
                    )
                  : Text(
                      'Error retrieving button tap count:\n${_error.message}',
                    ),
            ),
          ),
          ListTile(
            leading: Checkbox(
              onChanged: (bool value) {
                setState(() {
                  _anchorToBottom = value;
                });
              },
              value: _anchorToBottom,
            ),
            title: const Text('Anchor to bottom'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final DatabaseReference ref =
              FirebaseDatabase.instance.reference().child('counter');
          final DataSnapshot snapshot = await ref.once();
          final int value = snapshot.value ?? 0;
          final TransactionResult transactionResult =
              await ref.runTransaction((MutableData mutableData) async {
            mutableData.value = (mutableData.value ?? 0) + 1;
            return mutableData;
          });
          assert(transactionResult.committed, true);
          assert(transactionResult.dataSnapshot.value > value, true);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
