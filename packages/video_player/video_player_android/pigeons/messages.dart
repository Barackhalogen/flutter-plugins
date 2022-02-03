// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  dartTestOut: 'test/test_api.dart',
  javaOut: 'android/src/main/java/io/flutter/plugins/videoplayer/Messages.java',
  javaOptions: JavaOptions(
    package: 'io.flutter.plugins.videoplayer',
  ),
  copyrightHeader: 'pigeons/copyright.txt',
))
class TextureMessage {
  int? textureId;
}

class LoopingMessage {
  int? textureId;
  bool? isLooping;
}

class VolumeMessage {
  int? textureId;
  double? volume;
}

class PlaybackSpeedMessage {
  int? textureId;
  double? speed;
}

class PositionMessage {
  int? textureId;
  int? position;
}

class CreateMessage {
  String? asset;
  String? uri;
  String? packageName;
  String? formatHint;
  Map<String?, String?>? httpHeaders;
}

class MixWithOthersMessage {
  bool? mixWithOthers;
}

@HostApi(dartHostTestHandler: 'TestHostVideoPlayerApi')
abstract class VideoPlayerApi {
  void initialize();
  TextureMessage create(CreateMessage msg);
  void dispose(TextureMessage msg);
  void setLooping(LoopingMessage msg);
  void setVolume(VolumeMessage msg);
  void setPlaybackSpeed(PlaybackSpeedMessage msg);
  void play(TextureMessage msg);
  PositionMessage position(TextureMessage msg);
  void seekTo(PositionMessage msg);
  void pause(TextureMessage msg);
  void setMixWithOthers(MixWithOthersMessage msg);
}
