// Autogenerated from Pigeon (v0.1.21), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import
// @dart = 2.12
import 'dart:async';
import 'dart:typed_data' show Uint8List, Int32List, Int64List, Float64List;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'messages.dart';

abstract class TestHostVideoPlayerApi {
  void initialize();
  TextureMessage create(CreateMessage arg);
  void dispose(TextureMessage arg);
  void setLooping(LoopingMessage arg);
  void setVolume(VolumeMessage arg);
  void setPlaybackSpeed(PlaybackSpeedMessage arg);
  void play(TextureMessage arg);
  PositionMessage position(TextureMessage arg);
  void seekTo(PositionMessage arg);
  void pause(TextureMessage arg);
  void setMixWithOthers(MixWithOthersMessage arg);
  static void setup(TestHostVideoPlayerApi? api) {
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.initialize', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          // ignore message
          api.initialize();
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.create', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.create was null. Expected CreateMessage.');
          final CreateMessage input = CreateMessage.decode(message!);
          final TextureMessage output = api.create(input);
          return <Object?, Object?>{'result': output.encode()};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.dispose', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.dispose was null. Expected TextureMessage.');
          final TextureMessage input = TextureMessage.decode(message!);
          api.dispose(input);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.setLooping', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.setLooping was null. Expected LoopingMessage.');
          final LoopingMessage input = LoopingMessage.decode(message!);
          api.setLooping(input);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.setVolume', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.setVolume was null. Expected VolumeMessage.');
          final VolumeMessage input = VolumeMessage.decode(message!);
          api.setVolume(input);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.setPlaybackSpeed', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.setPlaybackSpeed was null. Expected PlaybackSpeedMessage.');
          final PlaybackSpeedMessage input = PlaybackSpeedMessage.decode(message!);
          api.setPlaybackSpeed(input);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.play', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.play was null. Expected TextureMessage.');
          final TextureMessage input = TextureMessage.decode(message!);
          api.play(input);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.position', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.position was null. Expected TextureMessage.');
          final TextureMessage input = TextureMessage.decode(message!);
          final PositionMessage output = api.position(input);
          return <Object?, Object?>{'result': output.encode()};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.seekTo', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.seekTo was null. Expected PositionMessage.');
          final PositionMessage input = PositionMessage.decode(message!);
          api.seekTo(input);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.pause', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.pause was null. Expected TextureMessage.');
          final TextureMessage input = TextureMessage.decode(message!);
          api.pause(input);
          return <Object?, Object?>{};
        });
      }
    }
    {
      const BasicMessageChannel<Object?> channel =
          BasicMessageChannel<Object?>('dev.flutter.pigeon.VideoPlayerApi.setMixWithOthers', StandardMessageCodec());
      if (api == null) {
        channel.setMockMessageHandler(null);
      } else {
        channel.setMockMessageHandler((Object? message) async {
          assert(message != null, 'Argument for dev.flutter.pigeon.VideoPlayerApi.setMixWithOthers was null. Expected MixWithOthersMessage.');
          final MixWithOthersMessage input = MixWithOthersMessage.decode(message!);
          api.setMixWithOthers(input);
          return <Object?, Object?>{};
        });
      }
    }
  }
}
