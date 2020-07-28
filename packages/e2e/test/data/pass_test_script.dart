import 'dart:convert';

import 'package:e2e/e2e.dart';
import 'package:flutter_test/flutter_test.dart';

void main() async {
  final E2EWidgetsFlutterBinding binding =
      E2EWidgetsFlutterBinding.ensureInitialized();

  testWidgets('passing test 1', (WidgetTester tester) async {
    expect(true, true);
  });

  testWidgets('passing test 2', (WidgetTester tester) async {
    expect(true, true);
  });

  tearDownAll(() {
    print(
        'E2EWidgetsFlutterBinding test results: ${jsonEncode(binding.results)}');
  });
}
