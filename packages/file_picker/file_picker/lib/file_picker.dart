// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker_platform_interface/file_picker_platform_interface.dart';

export 'package:file_picker_platform_interface/file_picker_platform_interface.dart'
  show XFile, XTypeGroup, XType;

/// NEW API

/// Open file dialog for loading files and return a file path
Future<XFile> loadFile({List<XTypeGroup> acceptedTypeGroups}) {
  return FilePickerPlatform.instance.loadFile(acceptedTypeGroups: acceptedTypeGroups);
}

/// Open file dialog for loading files and return a list of file paths
Future<List<XFile>> loadFiles({List<XTypeGroup> acceptedTypeGroups}) {
  return FilePickerPlatform.instance.loadFiles(acceptedTypeGroups: acceptedTypeGroups);
}

/// Saves File to user's file system
Future<String> getSavePath() async {
  return FilePickerPlatform.instance.getSavePath();
}