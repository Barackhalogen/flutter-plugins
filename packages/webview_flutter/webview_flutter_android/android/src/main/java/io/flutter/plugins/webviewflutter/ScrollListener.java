// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.webviewflutter;

public interface ScrollListener {
  void onScrollPosChange(int x, int y, int oldX, int oldY);
}
