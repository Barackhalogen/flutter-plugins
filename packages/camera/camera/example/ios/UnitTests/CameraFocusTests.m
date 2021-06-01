//
//  camera_exampleTests.m
//  camera_exampleTests
//
//  Created by Rene Floor on 31/05/2021.
//  Copyright © 2021 The Flutter Authors. All rights reserved.
//

@import camera;
@import XCTest;
#import <AVFoundation/AVFoundation.h>
#import <OCMock/OCMock.h>

// Mirrors FocusMode in camera.dart
typedef enum {
  FocusModeAuto,
  FocusModeLocked,
} FocusMode;

@interface FLTCam : NSObject <FlutterTexture,
                              AVCaptureVideoDataOutputSampleBufferDelegate,
                              AVCaptureAudioDataOutputSampleBufferDelegate>

- (void)applyFocusMode;
- (void)applyFocusMode:(FocusMode)focusMode onDevice:(AVCaptureDevice *)captureDevice;
@end

@interface CameraFocusTests : XCTestCase
@property(readonly, nonatomic) FLTCam *camera;
@property(readonly, nonatomic) id mockDevice;

@end

@implementation CameraFocusTests

- (void)setUp {
  _camera = [[FLTCam alloc] init];
  _mockDevice = OCMClassMock([AVCaptureDevice class]);
}

- (void)tearDown {
  // Put teardown code here. This method is called after the invocation of each test method in the
  // class.
}

- (void)testAutoFocusWithContinuousModeSupported_ShouldSetContinuousAutoFocus {
  // AVCaptureFocusModeContinuousAutoFocus is supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]).andReturn(true);
  // AVCaptureFocusModeContinuousAutoFocus is supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]).andReturn(true);

  // Don't expect setFocusMode:AVCaptureFocusModeAutoFocus
  [[_mockDevice reject] setFocusMode:AVCaptureFocusModeAutoFocus];

  // Run test
  [_camera applyFocusMode:FocusModeAuto onDevice:_mockDevice];

  // Expect setFocusMode:AVCaptureFocusModeContinuousAutoFocus
  OCMVerify([_mockDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus]);
}

- (void)testAutoFocusWithContinuousModeNotSupported_ShouldSetAutoFocus {
  // AVCaptureFocusModeContinuousAutoFocus is not supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
      .andReturn(false);
  // AVCaptureFocusModeContinuousAutoFocus is supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]).andReturn(true);

  // Don't expect setFocusMode:AVCaptureFocusModeContinuousAutoFocus
  [[_mockDevice reject] setFocusMode:AVCaptureFocusModeContinuousAutoFocus];

  // Run test
  [_camera applyFocusMode:FocusModeAuto onDevice:_mockDevice];

  // Expect setFocusMode:AVCaptureFocusModeAutoFocus
  OCMVerify([_mockDevice setFocusMode:AVCaptureFocusModeAutoFocus]);
}

- (void)testAutoFocusWithNoModeSupported_ShouldSetNothing {
  // AVCaptureFocusModeContinuousAutoFocus is not supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus])
      .andReturn(false);
  // AVCaptureFocusModeContinuousAutoFocus is not supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]).andReturn(false);

  // Don't expect any setFocus
  [[_mockDevice reject] setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
  [[_mockDevice reject] setFocusMode:AVCaptureFocusModeAutoFocus];

  // Run test
  [_camera applyFocusMode:FocusModeAuto onDevice:_mockDevice];
}

- (void)testLockedFocusWithModeSupported_ShouldSetModeAutoFocus {
  // AVCaptureFocusModeContinuousAutoFocus is supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]).andReturn(true);
  // AVCaptureFocusModeContinuousAutoFocus is supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]).andReturn(true);

  // Don't expect any setFocus
  [[_mockDevice reject] setFocusMode:AVCaptureFocusModeContinuousAutoFocus];

  // Run test
  [_camera applyFocusMode:FocusModeLocked onDevice:_mockDevice];

  // Expect setFocusMode:AVCaptureFocusModeAutoFocus
  OCMVerify([_mockDevice setFocusMode:AVCaptureFocusModeAutoFocus]);
}

- (void)testLockedFocusWithModeNotSupported_ShouldSetNothing {
  // AVCaptureFocusModeContinuousAutoFocus is supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]).andReturn(true);
  // AVCaptureFocusModeContinuousAutoFocus is not supported
  OCMStub([_mockDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus])
      .andReturn(true);  // Should be true, but checking CI.

  // Don't expect any setFocus
  [[_mockDevice reject] setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
  [[_mockDevice reject] setFocusMode:AVCaptureFocusModeAutoFocus];

  // Run test
  [_camera applyFocusMode:FocusModeLocked onDevice:_mockDevice];
}

@end
