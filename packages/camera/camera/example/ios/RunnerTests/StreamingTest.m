// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@import camera;
@import camera.Test;
@import XCTest;
@import AVFoundation;
#import <OCMock/OCMock.h>
#import "CameraTestUtils.h"

@interface StreamingTests : XCTestCase
@property(readonly, nonatomic) FLTCam *camera;
@property(readonly, nonatomic) CMSampleBufferRef sampleBuffer;
@end

@implementation StreamingTests

- (void)setUp {
  dispatch_queue_t captureSessionQueue = dispatch_queue_create("testing", NULL);
  _camera = FLTCreateCamWithCaptureSessionQueue(captureSessionQueue);
  _sampleBuffer = FLTCreateTestSampleBuffer();
}

- (void)tearDown {
  CFRelease(_sampleBuffer);
}

- (void)testExceedMaxStreamingPendingFramesCount {
  XCTestExpectation *streamingExpectation = [self
      expectationWithDescription:@"Must not call handler over maxStreamingPendingFramesCount"];

  id handlerMock = OCMClassMock([FLTImageStreamHandler class]);
  OCMStub([handlerMock alloc]).andReturn(handlerMock);
  OCMStub([handlerMock initWithCaptureSessionQueue:[OCMArg any]]).andReturn(handlerMock);
  OCMStub([handlerMock eventSink]).andReturn(^(id event) {
    [streamingExpectation fulfill];
  });

  id messenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
  [_camera startImageStreamWithMessenger:messenger];

  while (!_camera.isStreamingImages) {
    [NSThread sleepForTimeInterval:0.001];
  }

  streamingExpectation.expectedFulfillmentCount = 4;
  for (int i = 0; i < 10; i++) {
    [_camera captureOutput:nil didOutputSampleBuffer:self.sampleBuffer fromConnection:nil];
  }

  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

- (void)testReceivedImageStreamData {
  XCTestExpectation *streamingExpectation =
      [self expectationWithDescription:
                @"Must be able to call the handler again when receivedImageStreamData is called"];

  id handlerMock = OCMClassMock([FLTImageStreamHandler class]);
  OCMStub([handlerMock alloc]).andReturn(handlerMock);
  OCMStub([handlerMock initWithCaptureSessionQueue:[OCMArg any]]).andReturn(handlerMock);
  OCMStub([handlerMock eventSink]).andReturn(^(id event) {
    [streamingExpectation fulfill];
  });

  id messenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
  [_camera startImageStreamWithMessenger:messenger];

  while (!_camera.isStreamingImages) {
    [NSThread sleepForTimeInterval:0.001];
  }

  streamingExpectation.expectedFulfillmentCount = 5;
  for (int i = 0; i < 10; i++) {
    [_camera captureOutput:nil didOutputSampleBuffer:self.sampleBuffer fromConnection:nil];
  }

  [_camera receivedImageStreamData];
  [_camera captureOutput:nil didOutputSampleBuffer:self.sampleBuffer fromConnection:nil];

  [self waitForExpectationsWithTimeout:3.0 handler:nil];
}

@end
