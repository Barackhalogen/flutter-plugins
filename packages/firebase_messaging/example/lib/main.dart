// Copyright 2017 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

final Map<String, Item> _items = <String, Item>{};
Item _itemForMessage(Map<String, dynamic> message) {
  String itemId = message['id'];
  Item item = _items.putIfAbsent(itemId, () => new Item(itemId: itemId))
    ..status = message['status'];
  return item;
}

class Item {
  Item({this.itemId});
  final String itemId;

  StreamController<Item> _controller = new StreamController<Item>.broadcast();
  Stream<Item> get onChanged => _controller.stream;

  String _status;
  String get status => _status;
  set status(String value) {
    _status = value;
    _controller.add(this);
  }

  static final Map<String, Route> routes = <String, Route>{};
  Route get route {
    String routeName = '/detail/$itemId';
    return routes.putIfAbsent(
      routeName,
      () => new MaterialPageRoute(
            settings: new RouteSettings(name: routeName),
            builder: (BuildContext context) => new DetailPage(itemId),
          ),
    );
  }
}

class DetailPage extends StatefulWidget {
  DetailPage(this.itemId);
  final String itemId;
  @override
  _DetailPageState createState() => new _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Item _item;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _item = _items[widget.itemId];
    _subscription = _item.onChanged.listen((Item item) {
      if (!mounted) {
        _subscription.cancel();
      } else {
        setState(() {
          _item = item;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Item ${_item.itemId}"),
      ),
      body: new Material(
        child: new Center(child: new Text("Item status: ${_item.status}")),
      ),
    );
  }
}

class PushMessagingExample extends StatefulWidget {
  @override
  _PushMessagingExampleState createState() => new _PushMessagingExampleState();
}

class _PushMessagingExampleState extends State<PushMessagingExample> {
  String _homeScreenText = "Waiting for token...";
  bool _topicButtonsDisabled = false;

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  final TextEditingController _topicController =
      new TextEditingController(text: 'topic');

  Future<Null> _showItemDialog(Map<String, dynamic> message) async {
    Item item = _itemForMessage(message);
    showDialog(
        context: context,
        child: new AlertDialog(
          content: new Text("Item ${item.itemId} has been updated"),
          actions: <Widget>[
            new FlatButton(
                child: new Text('CLOSE'),
                onPressed: () {
                  Navigator.pop(context, false);
                }),
            new FlatButton(
                child: new Text('SHOW'),
                onPressed: () {
                  Navigator.pop(context, true);
                }),
          ],
        )).then((bool shouldNavigate) {
      if (shouldNavigate == true) _navigateToItemDetail(message);
    });
  }

  Future<Null> _navigateToItemDetail(Map<String, dynamic> message) async {
    Item item = _itemForMessage(message);
    // Clear away dialogs
    Navigator.popUntil(context, (Route<dynamic> route) => route is PageRoute);
    if (!item.route.isCurrent) Navigator.push(context, item.route);
  }

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
        _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
        _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
        _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _homeScreenText = "Push Messaging token: $token";
      });
      print(_homeScreenText);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Push Messaging Demo'),
        ),
        // For testing -- simulate a message being received
        floatingActionButton: new FloatingActionButton(
          onPressed: () => _showItemDialog(<String, dynamic>{
                "id": "2",
                "status": "out of stock",
              }),
          tooltip: 'Simulate Message',
          child: new Icon(Icons.message),
        ),
        body: new Material(
          child: new Column(
            children: [
              new Center(
                child: new Text(_homeScreenText),
              ),
              new Row(children: [
                new Expanded(
                  child: new TextField(
                      controller: _topicController,
                      onChanged: (String v) {
                        setState(() {
                          _topicButtonsDisabled = v.length == 0;
                        });
                      }),
                ),
                new FlatButton(
                  child: new Text("subscribe"),
                  onPressed: _topicButtonsDisabled
                      ? null
                      : () {
                          _firebaseMessaging
                              .subscribeToTopic(_topicController.text);
                          _clearTopicText();
                        },
                ),
                new FlatButton(
                  child: new Text("unsubscribe"),
                  onPressed: _topicButtonsDisabled
                      ? null
                      : () {
                          _firebaseMessaging
                              .unsubscribeFromTopic(_topicController.text);
                          _clearTopicText();
                        },
                ),
              ])
            ],
          ),
        ));
  }

  void _clearTopicText() {
    setState(() {
      _topicController.text = "";
      _topicButtonsDisabled = true;
    });
  }
}

void main() {
  runApp(
    new MaterialApp(
      home: new PushMessagingExample(),
    ),
  );
}
