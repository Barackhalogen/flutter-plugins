// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';

import '../platform_interface/file_selector_interface.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.io/file_picker');

/// An implementation of [FileSelectorPlatform] that uses method channels.
class MethodChannelFileSelector extends FileSelectorPlatform {
  /// Load a file from user's computer and return it as an XFile
  @override
  Future<XFile> loadFile({
    List<XTypeGroup> acceptedTypeGroups,
    String initialDirectory,
    String confirmButtonText,
  }) {
    return _channel.invokeMethod<XFile>(
      'loadFile',
      <String, Object>{
        'acceptedTypes': acceptedTypeGroups,
        'initialDirectory': initialDirectory,
      },
    );
  }

  /// Load multiple files from user's computer and return it as an XFile
  @override
  Future<List<XFile>> loadFiles({
    List<XTypeGroup> acceptedTypeGroups,
    String initialDirectory,
    String confirmButtonText,
  }) {
    return _channel.invokeMethod<List<XFile>>(
      'loadFiles',
      <String, Object>{
        'acceptedTypes': acceptedTypeGroups,
        'initialDirectory': initialDirectory,
      },
    );
  }

  /// Saves the file to user's Disk
  @override
  Future<String> getSavePath({
    List<XTypeGroup> acceptedTypeGroups,
    String initialDirectory,
    String suggestedName,
    String confirmButtonText,
  }) async {
    return _channel.invokeMethod(
      'saveFile',
      <String, Object>{
        'initialDirectory': initialDirectory,
        'suggestedName': suggestedName,
      },
    );
  }
}
