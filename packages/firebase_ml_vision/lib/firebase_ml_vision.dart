// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library firebase_ml_vision;

import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:firebase_ml_vision/src/vision_model_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:firebase_ml_vision/live_view.dart';

part 'src/barcode_detector.dart';
part 'src/face_detector.dart';
part 'src/firebase_vision.dart';
part 'src/label_detector.dart';
part 'src/text_detector.dart';