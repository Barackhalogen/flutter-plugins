import 'dart:async';

import 'package:flutter/services.dart';

import 'url_launcher_platform_interface.dart';

const MethodChannel _channel = MethodChannel('plugins.flutter.io/url_launcher');

/// An implementation of [UrlLauncherPlatform] that uses method channels.
class MethodChannelUrlLauncher extends UrlLauncherPlatform {
  @override
  Future<bool> canLaunch(String url) {
    return _channel.invokeMethod<bool>(
      'canLaunch',
      <String, Object>{'url': url},
    );
  }

  @override
  Future<void> closeWebView() {
    return _channel.invokeMethod<void>('closeWebView');
  }

  @override
  Future<bool> launch(
    String url,
    bool useSafariVC,
    bool useWebView,
    bool enableJavaScript,
    bool enableDomStorage,
    bool universalLinksOnly,
    Map<String, String> headers,
  ) {
    return _channel.invokeMethod<bool>(
      'launch',
      <String, Object>{
        'url': url,
        'useSafariVC': useSafariVC,
        'useWebView': useWebView,
        'enableJavaScript': enableJavaScript,
        'enableDomStorage': enableDomStorage,
        'universalLinksOnly': universalLinksOnly,
        'headers': headers,
      },
    );
  }
}
