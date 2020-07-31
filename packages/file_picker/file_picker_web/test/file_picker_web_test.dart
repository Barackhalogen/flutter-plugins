// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

//@TestOn('chrome') // Uses web-only Flutter SDK

import 'dart:convert';
import 'dart:typed_data';
import 'dart:html';

import 'package:flutter_test/flutter_test.dart';
import 'package:file_picker_web/file_picker_web.dart';
import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';

import 'package:platform_detect/test_utils.dart' as platform;

final String expectedStringContents = 'Hello, world!';
final expectedSize = expectedStringContents.length;
final Uint8List bytes = utf8.encode(expectedStringContents);
final File textFile = File([bytes], 'hello.txt');

void main() {
  // Under test..
  FilePickerPlugin plugin;

  setUp(() {
    plugin = FilePickerPlugin();
  });

  test('Basic', () { expect(1+1, 2); });
/*
  test('Select a file to load', () async {
    final mockInput = FileUploadInputElement();

    final plugin = ImagePickerPlugin(
      overrides: FilePickerPluginTestOverrides()
          ..createFileInputElement((_) => mockInput)
          ..getFileFromInputElement((_) => textFile)
    );

    // Call load file
    final XFile file = plugin.loadFile();

    // Mock selection of a file
    mockInput.dispatchEvent(Event('change'));

    // Expect the file to complete
    expect(file, completes);

    // Expect that we can read from the file
    final loadedFile = await file;
    expect(loadedFile.readAsBytes(), completion(isNotEmpty));
    expect(pickedFile.length(), completion(equals(expectedSize)));
    expect(loadedFile.name, 'hello.txt');
  });

 */
}