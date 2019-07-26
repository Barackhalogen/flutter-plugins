// Copyright 2019, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
part of firebase_crashlytics;

/// The entry point for accessing Crashlytics.
///
/// You can get an instance by calling `Crashlytics.instance`.
class Crashlytics {
  static final Crashlytics instance = Crashlytics();

  /// Set to true to have errors sent to Crashlytics while in debug mode. By
  /// default this is false.
  bool enableInDevMode = false;

  /// Keys to be included with report.
  final Map<String, dynamic> _keys = <String, dynamic>{};

  /// Logs to be included with report.
  final ListQueue<String> _logs = ListQueue<String>(15);
  int _logSize = 0;

  @visibleForTesting
  static const MethodChannel channel =
      MethodChannel('plugins.flutter.io/firebase_crashlytics');

  /// Submits report of a non-fatal error caught by the Flutter framework.
  /// to Firebase Crashlytics.
  Future<void> recordFlutterError(FlutterErrorDetails details) async {
    print('Flutter error caught by Crashlytics plugin:');

    _recordError(details.exceptionAsString(), details.stack,
        context: details.context,
        information: details.informationCollector == null
            ? null
            : details.informationCollector());
  }

  /// Submits a report of a non-fatal error.
  ///
  /// For errors generated by the Flutter framework, use [recordFlutterError] instead.
  Future<void> recordError(dynamic exception, StackTrace stack,
      {dynamic context}) async {
    print('Error caught by Crashlytics plugin <recordError>:');

    _recordError(exception, stack, context: context);
  }

  void crash() {
    throw StateError('Error thrown by Crashlytics plugin');
  }

  /// Reports the global value for debug mode.
  /// TODO(kroikie): Clarify what this means in context of both Android and iOS.
  Future<bool> isDebuggable() async {
    final bool result =
        await channel.invokeMethod<bool>('Crashlytics#isDebuggable');
    return result;
  }

  /// Returns Crashlytics SDK version.
  Future<String> getVersion() async {
    final String result =
        await channel.invokeMethod<String>('Crashlytics#getVersion');
    return result;
  }

  /// Add text logging that will be sent with your next report. `msg` will be
  /// printed to the console when in debug mode. Each report has a rolling max
  /// of 64k of logs, older logs are removed to allow newer logs to fit within
  /// the limit.
  void log(String msg) {
    _logSize += Uint8List.fromList(msg.codeUnits).length;
    _logs.add(msg);
    // Remove oldest log till logSize is no more than 64K.
    while (_logSize > 65536) {
      final String first = _logs.removeFirst();
      _logSize -= Uint8List.fromList(first.codeUnits).length;
    }
  }

  void _setValue(String key, dynamic value) {
    // Check that only 64 keys are set.
    if (_keys.containsKey(key) || _keys.length <= 64) {
      _keys[key] = value;
    }
  }

  /// Sets a value to be associated with a given key for your crash data.
  void setBool(String key, bool value) {
    _setValue(key, value);
  }

  /// Sets a value to be associated with a given key for your crash data.
  void setDouble(String key, double value) {
    _setValue(key, value);
  }

  /// Sets a value to be associated with a given key for your crash data.
  void setInt(String key, int value) {
    _setValue(key, value);
  }

  /// Sets a value to be associated with a given key for your crash data.
  void setString(String key, String value) {
    _setValue(key, value);
  }

  /// Optionally set a end-user's name or username for display within the
  /// Crashlytics UI. Please be mindful of end-user's privacy.
  Future<void> setUserEmail(String email) async {
    await channel.invokeMethod<void>(
        'Crashlytics#setUserEmail', <String, dynamic>{'email': email});
  }

  /// Specify a user identifier which will be visible in the Crashlytics UI.
  /// Please be mindful of end-user's privacy.
  Future<void> setUserIdentifier(String identifier) async {
    await channel.invokeMethod<void>('Crashlytics#setUserIdentifier',
        <String, dynamic>{'identifier': identifier});
  }

  /// Specify a user name which will be visible in the Crashlytics UI. Please
  /// be mindful of end-user's privacy.
  Future<void> setUserName(String name) async {
    await channel.invokeMethod<void>(
        'Crashlytics#setUserName', <String, dynamic>{'name': name});
  }

  List<Map<String, dynamic>> _prepareKeys() {
    final List<Map<String, dynamic>> crashlyticsKeys = <Map<String, dynamic>>[];
    for (String key in _keys.keys) {
      final dynamic value = _keys[key];

      final Map<String, dynamic> crashlyticsKey = <String, dynamic>{
        'key': key,
        'value': value
      };

      if (value is int) {
        crashlyticsKey['type'] = 'int';
      } else if (value is double) {
        crashlyticsKey['type'] = 'double';
      } else if (value is String) {
        crashlyticsKey['type'] = 'string';
      } else if (value is bool) {
        crashlyticsKey['type'] = 'boolean';
      }
      crashlyticsKeys.add(crashlyticsKey);
    }

    return crashlyticsKeys;
  }

  @visibleForTesting
  List<Map<String, String>> getStackTraceElements(List<String> lines) {
    final List<Map<String, String>> elements = <Map<String, String>>[];
    for (String line in lines) {
      final List<String> lineParts = line.split(RegExp('\\s+'));
      try {
        final String fileName = lineParts[0];
        final String lineNumber = lineParts[1].contains(":")
            ? lineParts[1].substring(0, lineParts[1].indexOf(":")).trim()
            : lineParts[1];

        final Map<String, String> element = <String, String>{
          'file': fileName,
          'line': lineNumber,
        };

        // The next section would throw an exception in some cases if there was no stop here.
        if (lineParts.length < 3) {
          elements.add(element);
          continue;
        }

        if (lineParts[2].contains(".")) {
          final String className =
              lineParts[2].substring(0, lineParts[2].indexOf(".")).trim();
          final String methodName =
              lineParts[2].substring(lineParts[2].indexOf(".") + 1).trim();

          element['class'] = className;
          element['method'] = methodName;
        } else {
          element['method'] = lineParts[2];
        }

        elements.add(element);
      } catch (e) {
        print(e.toString());
      }
    }
    return elements;
  }

  /// On top of the default exception components, [information] can be passed as well.
  /// This allows the developer to get a better understanding of exceptions thrown
  /// by the Flutter framework. [FlutterErrorDetails] often explain why an exception
  /// occurred and give useful background information in [FlutterErrorDetails.informationCollector].
  /// Crashlytics will log this information in addition to the stack trace.
  /// If [information] is `null` or empty, it will be ignored.
  Future<void> _recordError(dynamic exception, StackTrace stack,
      {dynamic context, Iterable<DiagnosticsNode> information}) async {
    bool inDebugMode = false;
    if (!enableInDevMode) {
      assert(inDebugMode = true);
    }

    final String _information = (information == null || information.isEmpty)
        ? ''
        : (StringBuffer()..writeAll(information, '\n')).toString();

    if (inDebugMode && !enableInDevMode) {
      // If available, give context to the exception.
      if (context != null)
        print('The following exception was thrown $context:');

      // Need to print the exception to explain why the exception was thrown.
      print(exception);

      // Print information provided by the Flutter framework about the exception.
      if (_information.isNotEmpty) print('\n$_information');

      // Not using Trace.format here to stick to the default stack trace format
      // that Flutter developers are used to seeing.
      if (stack != null) print('\n$stack');
    } else {
      // The stack trace can be null. To avoid the following exception:
      // Invalid argument(s): Cannot create a Trace from null.
      // To avoid that exception, we can check for null and provide an empty stack trace.
      if (stack == null) stack = StackTrace.fromString('');

      // Report error.
      final List<String> stackTraceLines =
          Trace.format(stack).trimRight().split('\n');
      final List<Map<String, String>> stackTraceElements =
          getStackTraceElements(stackTraceLines);
      final String result = await channel
          .invokeMethod<String>('Crashlytics#onError', <String, dynamic>{
        'exception': "${exception.toString()}",
        'context': '$context',
        'information': _information,
        'stackTraceElements': stackTraceElements,
        'logs': _logs.toList(),
        'keys': _prepareKeys(),
      });

      // Print result.
      print(result);
    }
  }
}
