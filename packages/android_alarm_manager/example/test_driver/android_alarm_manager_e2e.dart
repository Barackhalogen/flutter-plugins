// Copyright 2019, the Chromium project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:e2e/e2e.dart';
import 'package:path_provider/path_provider.dart';

// From https://flutter.dev/docs/cookbook/persistence/reading-writing-files
Future<String> get _localPath async {
  final directory = await getTemporaryDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/counter.txt');
}

Future<File> writeCounter(int counter) async {
  final file = await _localFile;

  // Write the file.
  return file.writeAsString('$counter');
}

Future<int> readCounter() async {
  try {
    final file = await _localFile;

    // Read the file.
    String contents = await file.readAsString();

    return int.parse(contents);
  } catch (e) {
    // If encountering an error, return 0.
    return 0;
  }
}

Future<void> incrementCounter() async {
  int value = await readCounter();
  await writeCounter(value + 1);
}

void main() {
  E2EWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await AndroidAlarmManager.initialize();
  });

  group('oneshot', () {
    testWidgets('cancelled before it fires', (WidgetTester tester) async {
      final int alarmId = 0;
      final int startingValue = await readCounter();
      await AndroidAlarmManager.oneShot(
      const Duration(seconds: 1), alarmId, incrementCounter);
      expect(await AndroidAlarmManager.cancel(alarmId), isTrue);
      await new Future.delayed(const Duration(seconds: 4));
      expect(await readCounter(), startingValue);
    });

    testWidgets('cancelled after it fires', (WidgetTester tester) async {
      final int alarmId = 1;
      final int startingValue = await readCounter();
      await AndroidAlarmManager.oneShot(
      const Duration(seconds: 1), alarmId, incrementCounter);
      await new Future.delayed(const Duration(seconds: 2));
      // poll until file is updated
      for (int i = 0; i < 10 && await readCounter() == startingValue; i++) {
        await new Future.delayed(const Duration(seconds: 1));
      }
      expect(await readCounter(), startingValue + 1);
      expect(await AndroidAlarmManager.cancel(alarmId), isTrue);
    });
  });

  testWidgets('periodic', (WidgetTester tester) async {
    final int alarmId = 2;
    final int startingValue = await readCounter();
    await AndroidAlarmManager.periodic(
        const Duration(seconds: 1), alarmId, incrementCounter,
        wakeup: true);
    // poll until file is updated
    for (int i = 0; i < 10 && await readCounter() < startingValue + 3; i++) {
      await new Future.delayed(const Duration(seconds: 1));
    }
    expect(await readCounter(), startingValue + 3);
    expect(await AndroidAlarmManager.cancel(alarmId), isTrue);
    await new Future.delayed(const Duration(seconds: 3));
    expect(await readCounter(), startingValue + 3);
  });
}
