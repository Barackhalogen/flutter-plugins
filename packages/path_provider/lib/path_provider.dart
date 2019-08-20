// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

const MethodChannel _channel =
    MethodChannel('plugins.flutter.io/path_provider');

/// Path to the temporary directory on the device that is not backed up and is
/// suitable for storing caches of downloaded files.
///
/// Files in this directory may be cleared at any time. This does *not* return
/// a new temporary directory. Instead, the caller is responsible for creating
/// (and cleaning up) files or directories within this directory. This
/// directory is scoped to the calling application.
///
/// On iOS, this uses the `NSCachesDirectory` API.
///
/// On Android, this uses the `getCacheDir` API on the context.
Future<Directory> getTemporaryDirectory() async {
  final String path =
      await _channel.invokeMethod<String>('getTemporaryDirectory');
  if (path == null) {
    return null;
  }
  return Directory(path);
}

/// Path to a directory where the application may place application support
/// files.
///
/// Use this for files you don’t want exposed to the user. Your app should not
/// use this directory for user data files.
///
/// On iOS, this uses the `NSApplicationSupportDirectory` API.
/// If this directory does not exist, it is created automatically.
///
/// On Android, this function uses the `getFilesDir` API on the context.
Future<Directory> getApplicationSupportDirectory() async {
  final String path =
      await _channel.invokeMethod<String>('getApplicationSupportDirectory');
  if (path == null) {
    return null;
  }

  return Directory(path);
}

/// Path to a directory where the application may place data that is
/// user-generated, or that cannot otherwise be recreated by your application.
///
/// On iOS, this uses the `NSDocumentDirectory` API. Consider using
/// [getApplicationSupportDirectory] instead if the data is not user-generated.
///
/// On Android, this uses the `getDataDirectory` API on the context. Consider
/// using [getExternalStorageDirectory] instead if data is intended to be visible
/// to the user.
Future<Directory> getApplicationDocumentsDirectory() async {
  final String path =
      await _channel.invokeMethod<String>('getApplicationDocumentsDirectory');
  if (path == null) {
    return null;
  }
  return Directory(path);
}

/// Path to a directory where the application may access top level storage.
/// The current operating system should be determined before issuing this
/// function call, as this functionality is only available on Android.
///
/// On iOS, this function throws an [UnsupportedError] as it is not possible
/// to access outside the app's sandbox.
///
/// On Android this uses the `getExternalFilesDir(null)`.
Future<Directory> getExternalStorageDirectory() async {
  if (Platform.isIOS)
    throw UnsupportedError("Functionality not available on iOS");
  final String path =
      await _channel.invokeMethod<String>('getStorageDirectory');
  if (path == null) {
    return null;
  }
  return Directory(path);
}

/// Paths to directories where application specific cache data can be stored.
/// These paths typically reside on external storage like separate partitions
/// or SD cards. Phones may have multiple storage directories available.
///
/// The current operating system should be determined before issuing this
/// function call, as this functionality is only available on Android.
///
/// On iOS, this function throws an UnsupportedError as it is not possible
/// to access outside the app's sandbox.
///
/// On Android this returns Context.getExternalCacheDirs() or
/// Context.getExternalCacheDir() on API levels below 19.
Future<List<Directory>> getExternalCacheDirectories() async {
  if (Platform.isIOS)
    throw UnsupportedError("Functionality not available on iOS");
  final List<String> paths =
      await _channel.invokeListMethod<String>('getExternalCacheDirectories');

  return (paths ?? const <String>[])
      .map((String path) => Directory(path))
      .toList();
}

/// Paths to directories where application specific data can be stored.
/// These paths typically reside on external storage like separate partitions
/// or SD cards. Phones may have multiple storage directories available.
///
/// The current operating system should be determined before issuing this
/// function call, as this functionality is only available on Android.
///
/// On iOS, this function throws an UnsupportedError as it is not possible
/// to access outside the app's sandbox.
///
/// The parameter type is optional. If it is set, it must be one of the
/// "DIRECTORY" constants defined in `android.os.Environment`, e.g.
/// https://developer.android.com/reference/android/os/Environment#DIRECTORY_MUSIC
///
/// On Android this returns Context.getExternalFilesDirs(String type) or
/// Context.getExternalFilesDir(String type) on API levels below 19.
Future<List<Directory>> getExternalStorageDirectories(String type) async {
  if (Platform.isIOS)
    throw UnsupportedError("Functionality not available on iOS");
  final List<String> paths = await _channel.invokeListMethod<String>(
    'getExternalStorageDirectories',
    <String, String>{"type": type},
  );

  return (paths ?? <String>[]).map((String path) => Directory(path)).toList();
}
