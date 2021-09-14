// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Mocks generated by Mockito 5.0.15 from annotations
// in google_maps_flutter_web_integration_tests/integration_test/google_maps_plugin_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i2;

import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart'
    as _i3;
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart' as _i4;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis

class _FakeStreamController_0<T> extends _i1.Fake
    implements _i2.StreamController<T> {}

class _FakeLatLngBounds_1 extends _i1.Fake implements _i3.LatLngBounds {}

class _FakeScreenCoordinate_2 extends _i1.Fake implements _i3.ScreenCoordinate {
}

class _FakeLatLng_3 extends _i1.Fake implements _i3.LatLng {}

/// A class which mocks [GoogleMapController].
///
/// See the documentation for Mockito's code generation for more information.
class MockGoogleMapController extends _i1.Mock
    implements _i4.GoogleMapController {
  @override
  _i2.StreamController<_i3.MapEvent<dynamic>> get stream =>
      (super.noSuchMethod(Invocation.getter(#stream),
              returnValue: _FakeStreamController_0<_i3.MapEvent<dynamic>>())
          as _i2.StreamController<_i3.MapEvent<dynamic>>);
  @override
  _i2.Stream<_i3.MapEvent<dynamic>> get events =>
      (super.noSuchMethod(Invocation.getter(#events),
              returnValue: Stream<_i3.MapEvent<dynamic>>.empty())
          as _i2.Stream<_i3.MapEvent<dynamic>>);
  @override
  bool get isInitialized =>
      (super.noSuchMethod(Invocation.getter(#isInitialized), returnValue: false)
          as bool);
  @override
  void debugSetOverrides(
          {_i4.DebugCreateMapFunction? createMap,
          _i4.MarkersController? markers,
          _i4.CirclesController? circles,
          _i4.PolygonsController? polygons,
          _i4.PolylinesController? polylines}) =>
      super.noSuchMethod(
          Invocation.method(#debugSetOverrides, [], {
            #createMap: createMap,
            #markers: markers,
            #circles: circles,
            #polygons: polygons,
            #polylines: polylines
          }),
          returnValueForMissingStub: null);
  @override
  void init() => super.noSuchMethod(Invocation.method(#init, []),
      returnValueForMissingStub: null);
  @override
  void updateRawOptions(Map<String, dynamic>? optionsUpdate) =>
      super.noSuchMethod(Invocation.method(#updateRawOptions, [optionsUpdate]),
          returnValueForMissingStub: null);
  @override
  _i2.Future<_i3.LatLngBounds> getVisibleRegion() => (super.noSuchMethod(
          Invocation.method(#getVisibleRegion, []),
          returnValue: Future<_i3.LatLngBounds>.value(_FakeLatLngBounds_1()))
      as _i2.Future<_i3.LatLngBounds>);
  @override
  _i2.Future<_i3.ScreenCoordinate> getScreenCoordinate(_i3.LatLng? latLng) =>
      (super.noSuchMethod(Invocation.method(#getScreenCoordinate, [latLng]),
              returnValue:
                  Future<_i3.ScreenCoordinate>.value(_FakeScreenCoordinate_2()))
          as _i2.Future<_i3.ScreenCoordinate>);
  @override
  _i2.Future<_i3.LatLng> getLatLng(_i3.ScreenCoordinate? screenCoordinate) =>
      (super.noSuchMethod(Invocation.method(#getLatLng, [screenCoordinate]),
              returnValue: Future<_i3.LatLng>.value(_FakeLatLng_3()))
          as _i2.Future<_i3.LatLng>);
  @override
  _i2.Future<void> moveCamera(_i3.CameraUpdate? cameraUpdate) =>
      (super.noSuchMethod(Invocation.method(#moveCamera, [cameraUpdate]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i2.Future<void>);
  @override
  _i2.Future<double> getZoomLevel() =>
      (super.noSuchMethod(Invocation.method(#getZoomLevel, []),
          returnValue: Future<double>.value(0.0)) as _i2.Future<double>);
  @override
  void updateCircles(_i3.CircleUpdates? updates) =>
      super.noSuchMethod(Invocation.method(#updateCircles, [updates]),
          returnValueForMissingStub: null);
  @override
  void updatePolygons(_i3.PolygonUpdates? updates) =>
      super.noSuchMethod(Invocation.method(#updatePolygons, [updates]),
          returnValueForMissingStub: null);
  @override
  void updatePolylines(_i3.PolylineUpdates? updates) =>
      super.noSuchMethod(Invocation.method(#updatePolylines, [updates]),
          returnValueForMissingStub: null);
  @override
  void updateMarkers(_i3.MarkerUpdates? updates) =>
      super.noSuchMethod(Invocation.method(#updateMarkers, [updates]),
          returnValueForMissingStub: null);
  @override
  void showInfoWindow(_i3.MarkerId? markerId) =>
      super.noSuchMethod(Invocation.method(#showInfoWindow, [markerId]),
          returnValueForMissingStub: null);
  @override
  void hideInfoWindow(_i3.MarkerId? markerId) =>
      super.noSuchMethod(Invocation.method(#hideInfoWindow, [markerId]),
          returnValueForMissingStub: null);
  @override
  bool isInfoWindowShown(_i3.MarkerId? markerId) =>
      (super.noSuchMethod(Invocation.method(#isInfoWindowShown, [markerId]),
          returnValue: false) as bool);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  String toString() => super.toString();
}
