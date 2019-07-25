// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of cloud_firestore;

class Blob {
  const Blob(this.bytes);

  final Uint8List bytes;

  @override
  bool operator ==(dynamic other) =>
      other is Blob &&
      const DeepCollectionEquality().equals(other.bytes, bytes);

  @override
  int get hashCode => hashList(bytes);
}
