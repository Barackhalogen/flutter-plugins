import 'dart:async';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:connectivity/connectivity.dart';

void main() {
  final Completer<String> completer = Completer<String>();
  enableFlutterDriverExtension(handler: (_) => completer.future);
  tearDownAll(() => completer.complete(null));

  group('Connectivity test driver', () {
    Connectivity _connectivity;

    setUpAll(() async {
      _connectivity = Connectivity();
    });

    test('test connectivity info', () async {
      final ConnectivityInfo info = await _connectivity.checkConnectivityInfo();
      expect(info, isNotNull);
      expect(info.subtype, ConnectionSubtype.unknown);
      switch (info.result) {
        case ConnectivityResult.wifi:
          expect(_connectivity.getWifiName(), completes);
          expect(_connectivity.getWifiBSSID(), completes);
          expect((await _connectivity.getWifiIP()), isNotNull);
          break;
        default:
          break;
      }
    });
  });
}
