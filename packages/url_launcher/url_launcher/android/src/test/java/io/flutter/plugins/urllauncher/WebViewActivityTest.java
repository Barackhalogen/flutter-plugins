// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.urllauncher;

import static org.junit.Assert.assertEquals;

import android.os.Bundle;
import java.util.Collections;
import java.util.Map;
import org.junit.Test;

public class WebViewActivityTest {
  @Test
  public void extractHeaders_returnsEmptyMapWhenHeadersBundleNull() {
    Bundle headersBundle = null;

    Map<String, String> expectedExtractedHeaders = Collections.emptyMap();
    assertEquals(WebViewActivity.extractHeaders(headersBundle), expectedExtractedHeaders);
  }
}
