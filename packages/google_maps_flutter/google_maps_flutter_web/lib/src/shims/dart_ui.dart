// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/// This file shims dart:ui in web-only scenarios, getting rid of the need to
/// suppress analyzer warnings.

export 'dart_ui_fake.dart' if (dart.library.html) 'dart_ui_real.dart';
