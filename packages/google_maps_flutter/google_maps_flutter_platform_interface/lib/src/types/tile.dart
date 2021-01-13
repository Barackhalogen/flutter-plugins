// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:typed_data';
import 'package:meta/meta.dart' show immutable;

/// Contains information about a Tile that is returned by a [TileProvider].
@immutable
class Tile {
  /// Creates an immutable representation of a [Tile] to draw by [TileProvider].
  const Tile(this.width, this.height, this.data);

  /// The width of the image encoded by data in pixels.
  final int width;

  /// The height of the image encoded by data in pixels.
  final int height;

  /// A byte array containing the image data.
  final Uint8List data;

  /// Converts this object to JSON.
  dynamic toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('width', width);
    addIfPresent('height', height);
    addIfPresent('data', data);

    return json;
  }
}
