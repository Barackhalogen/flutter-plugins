

// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

// Defines marker UI options writable from Flutter.
@protocol FLTGoogleMapPolylineOptionsSink
- (void)setConsumeTapEvents:(BOOL)consume;
- (void)setVisible:(BOOL)visible;
- (void)setColor:(UIColor*)color;
- (void)setStrokeWidth:(CGFloat)width;
- (void)setPoints:(NSMutableArray*)points;
- (void)setZIndex:(int)zIndex;
@end

// Defines marker controllable by Flutter.
@interface FLTGoogleMapPolylineController : NSObject <FLTGoogleMapPolylineOptionsSink>
@property(atomic, readonly) NSString* polylineId;
- (instancetype)init:(GMSMapView*)mapView;
- (BOOL)consumeTapEvents;
- (void)removeMarker;
@end


@interface FLTPolylinesController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(GMSMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addPolylines:(NSArray*)polylinesToAdd;
- (void)changePolylines:(NSArray*)polylinesToChange;
- (void)removePolylineIds:(NSArray*)polylineIdsToRemove;
- (BOOL)onPolylineTap:(NSString*)polylineId;
@end
