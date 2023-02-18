// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.webviewflutter;

import androidx.annotation.Nullable;
/** Define extending APIs for {@link android.webkit.WebView} */
public interface WebViewExtendedApi {
  void setContentOffsetChangedListener(
      @Nullable ContentOffsetChangedListener contentOffsetChangedListener);
}
