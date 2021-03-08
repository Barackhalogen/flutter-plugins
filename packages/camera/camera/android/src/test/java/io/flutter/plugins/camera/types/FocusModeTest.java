// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camera.types;

import static org.junit.Assert.assertEquals;

import io.flutter.plugins.camera.features.autofocus.FocusMode;
import org.junit.Test;

public class FocusModeTest {

  @Test
  public void getValueForString_returns_correct_values() {
    assertEquals(
        "Returns FocusMode.auto for 'auto'", FocusMode.getValueForString("auto"), FocusMode.auto);
    assertEquals(
        "Returns FocusMode.locked for 'locked'",
        FocusMode.getValueForString("locked"),
        FocusMode.locked);
  }

  @Test
  public void getValueForString_returns_null_for_nonexistant_value() {
    assertEquals(
        "Returns null for 'nonexistant'", FocusMode.getValueForString("nonexistant"), null);
  }

  @Test
  public void toString_returns_correct_value() {
    assertEquals("Returns 'auto' for FocusMode.auto", FocusMode.auto.toString(), "auto");
    assertEquals("Returns 'locked' for FocusMode.locked", FocusMode.locked.toString(), "locked");
  }
}
