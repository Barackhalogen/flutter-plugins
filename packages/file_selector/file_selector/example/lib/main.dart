// Copyright 2017 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:example/home_page.dart';
import 'package:example/get_directory_page.dart';
import 'package:example/open_text_page.dart';
import 'package:example/open_image_page.dart';
import 'package:example/open_multiple_images_page.dart';
import 'package:example/save_text_page.dart';

void main() {
  runApp(MyApp());
}

/// MyApp is the Main Application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Selector Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
      routes: {
        '/open/image': (context) => OpenImagePage(),
        '/open/images': (context) => OpenMultipleImagesPage(),
        '/open/text': (context) => OpenTextPage(),
        '/save/text': (context) => SaveTextPage(),
        '/directory': (context) => GetDirectoryPage(),
      },
    );
  }
}
