// Copyright 2020 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:path_provider_windows/folders.dart';

/// The Windows implementation of [PathProviderPlatform]
///
/// This class implements the `package:path_provider` functionality for Windows
class PathProviderWindows extends PathProviderPlatform {
  /// Path to the temporary directory on the device that is not backed up and is
  /// suitable for storing caches of downloaded files. This is typically the
  /// same as the TMP environment variable.
  @override
  Future<String> getTemporaryPath() {
    final buffer = allocate<Uint16>(count: MAX_PATH + 1).cast<Utf16>();
    String path;

    try {
      final length = GetTempPath(MAX_PATH, buffer);

      if (length == 0) {
        final error = GetLastError();
        free(buffer);
        throw WindowsException(error);
      } else {
        path = buffer.unpackString(length);

        // GetTempPath adds a trailing backslash, but SHGetKnownFolderPath does not.
        // Strip off trailing backslash for consistency with other methods here.
        if (path.endsWith('\\')) {
          path = path.substring(0, path.length - 1);
        }
      }
      return Future.value(path);
    } finally {
      free(buffer);
    }
  }

  /// Path to a directory where the application may place application support
  /// files.
  @override
  Future<String> getApplicationSupportPath() =>
      getPath(WindowsKnownFolder.ProgramData);

  /// Path to the directory where application can store files that are persistent,
  /// backed up, and not visible to the user, such as sqlite.db.
  @override
  Future<String> getLibraryPath() => getPath(WindowsKnownFolder.LocalAppData);

  /// Path to a directory where the application may place data that is
  /// user-generated, or that cannot otherwise be recreated by your application.
  @override
  Future<String> getApplicationDocumentsPath() =>
      getPath(WindowsKnownFolder.Documents);

  /// Path to the directory where downloaded files can be stored. This is
  /// typically the same as %USERPROFILE%\Downloads.
  @override
  Future<String> getDownloadsPath() => getPath(WindowsKnownFolder.Downloads);

  /// Retrieve any known folder from Windows.
  ///
  /// folderID is a GUID that represents a specific known folder ID, drawn from
  /// [WindowsKnownFolder].
  Future<String> getPath(String folderID) {
    final pathPtrPtr = allocate<IntPtr>();
    Pointer<Utf16> pathPtr;

    try {
      GUID knownFolderID = GUID.fromString(folderID);

      final hr = SHGetKnownFolderPath(
          knownFolderID.addressOf, KF_FLAG_DEFAULT, NULL, pathPtrPtr);

      if (FAILED(hr)) {
        if (hr == E_INVALIDARG || hr == E_FAIL) {
          throw WindowsException(hr);
        }
      }

      pathPtr = Pointer<Utf16>.fromAddress(pathPtrPtr.value);
      final path = pathPtr.unpackString(MAX_PATH);
      return Future.value(path);
    } finally {
      CoTaskMemFree(pathPtr.cast());
      free(pathPtrPtr);
    }
  }
}
