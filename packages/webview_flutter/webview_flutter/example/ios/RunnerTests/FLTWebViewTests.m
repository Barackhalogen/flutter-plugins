// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@import Flutter;
@import XCTest;
@import webview_flutter;

// OCMock library doesn't generate a valid modulemap.
#import <OCMock/OCMock.h>

static bool feq(CGFloat a, CGFloat b) { return fabs(b - a) < FLT_EPSILON; }

@interface FLTWebViewTests : XCTestCase

@property(strong, nonatomic) NSObject<FlutterBinaryMessenger> *mockBinaryMessenger;

@end

@implementation FLTWebViewTests

- (void)setUp {
  [super setUp];
  self.mockBinaryMessenger = OCMProtocolMock(@protocol(FlutterBinaryMessenger));
}

- (void)testCanInitFLTWebViewController {
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTAssertNotNil(controller);
}

- (void)testCanInitFLTWebViewFactory {
  FLTWebViewFactory *factory =
      [[FLTWebViewFactory alloc] initWithMessenger:self.mockBinaryMessenger];
  XCTAssertNotNil(factory);
}

- (void)webViewContentInsetBehaviorShouldBeNeverOnIOS11 {
  if (@available(iOS 11, *)) {
    FLTWebViewController *controller =
        [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                     viewIdentifier:1
                                          arguments:nil
                                    binaryMessenger:self.mockBinaryMessenger];
    UIView *view = controller.view;
    XCTAssertTrue([view isKindOfClass:WKWebView.class]);
    WKWebView *webView = (WKWebView *)view;
    XCTAssertEqual(webView.scrollView.contentInsetAdjustmentBehavior,
                   UIScrollViewContentInsetAdjustmentNever);
  }
}

- (void)testWebViewScrollIndicatorAticautomaticallyAdjustsScrollIndicatorInsetsShouldbeNoOnIOS13 {
  if (@available(iOS 13, *)) {
    FLTWebViewController *controller =
        [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                     viewIdentifier:1
                                          arguments:nil
                                    binaryMessenger:self.mockBinaryMessenger];
    UIView *view = controller.view;
    XCTAssertTrue([view isKindOfClass:WKWebView.class]);
    WKWebView *webView = (WKWebView *)view;
    XCTAssertFalse(webView.scrollView.automaticallyAdjustsScrollIndicatorInsets);
  }
}

- (void)testContentInsetsSumAlwaysZeroAfterSetFrame {
  FLTWKWebView *webView = [[FLTWKWebView alloc] initWithFrame:CGRectMake(0, 0, 300, 400)];
  webView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
  XCTAssertFalse(UIEdgeInsetsEqualToEdgeInsets(webView.scrollView.contentInset, UIEdgeInsetsZero));
  webView.frame = CGRectMake(0, 0, 300, 200);
  XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(webView.scrollView.contentInset, UIEdgeInsetsZero));
  XCTAssertTrue(CGRectEqualToRect(webView.frame, CGRectMake(0, 0, 300, 200)));

  if (@available(iOS 11, *)) {
    // After iOS 11, we need to make sure the contentInset compensates the adjustedContentInset.
    UIScrollView *partialMockScrollView = OCMPartialMock(webView.scrollView);
    UIEdgeInsets insetToAdjust = UIEdgeInsetsMake(0, 0, 300, 0);
    OCMStub(partialMockScrollView.adjustedContentInset).andReturn(insetToAdjust);
    XCTAssertTrue(UIEdgeInsetsEqualToEdgeInsets(webView.scrollView.contentInset, UIEdgeInsetsZero));
    webView.frame = CGRectMake(0, 0, 300, 100);
    XCTAssertTrue(feq(webView.scrollView.contentInset.bottom, -insetToAdjust.bottom));
    XCTAssertTrue(CGRectEqualToRect(webView.frame, CGRectMake(0, 0, 300, 100)));
  }
}

- (void)testEvaluateJavaScriptShouldCallCallAsyncJavaScriptIOS14AndAbove {
  if (@available(iOS 14, *)) {
    // Setup
    FLTWebViewController *controller =
        [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                     viewIdentifier:1
                                          arguments:nil
                                    binaryMessenger:self.mockBinaryMessenger];
    FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
    [OCMStub([mockView callAsyncJavaScript:[OCMArg any]
                                 arguments:[OCMArg any]
                                   inFrame:[OCMArg any]
                            inContentWorld:[OCMArg any]
                         completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
      // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
      __unsafe_unretained void (^evalResultHandler)(id, NSError *);
      [invocation getArgument:&evalResultHandler atIndex:6];
      evalResultHandler(@"RESULT", nil);
    }];
    controller.webView = mockView;
    XCTestExpectation *resultExpectation = [self
        expectationWithDescription:@"Should return successful result over the method channel."];

    // Run
    [controller onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"evaluateJavascript"
                                                               arguments:@"console.log('test')"]
                      result:^(id _Nullable result) {
                        XCTAssertTrue([@"RESULT" isEqualToString:result]);
                        [resultExpectation fulfill];
                      }];

    // Verify
    OCMVerify([mockView
        callAsyncJavaScript:[OCMArg isEqual:@"return eval(\"console.log('test')\");"]
                  arguments:[OCMArg any]
                    inFrame:[OCMArg any]
             inContentWorld:[OCMArg any]
          completionHandler:[OCMArg any]]);
    OCMReject([mockView evaluateJavaScript:[OCMArg any] completionHandler:[OCMArg any]]);
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
  }
}

- (void)testEvaluateJavaScriptShouldCallEvaluateJavaScriptBelowIOS14 {
  if (@available(iOS 14, *)) {
  } else {
    // Setup
    FLTWebViewController *controller =
        [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                     viewIdentifier:1
                                          arguments:nil
                                    binaryMessenger:self.mockBinaryMessenger];
    FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
    [OCMStub([mockView evaluateJavaScript:[OCMArg any]
                        completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
      // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
      __unsafe_unretained void (^evalResultHandler)(id, NSError *);
      [invocation getArgument:&evalResultHandler atIndex:3];
      evalResultHandler(@"RESULT", nil);
    }];
    controller.webView = mockView;
    XCTestExpectation *resultExpectation = [self
        expectationWithDescription:@"Should return successful result over the method channel."];

    // Run
    [controller onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"evaluateJavascript"
                                                               arguments:@"console.log('test')"]
                      result:^(id _Nullable result) {
                        XCTAssertTrue([@"RESULT" isEqualToString:result]);
                        [resultExpectation fulfill];
                      }];

    // Verify
    OCMVerify([mockView evaluateJavaScript:@"console.log('test')" completionHandler:[OCMArg any]]);
    [self waitForExpectationsWithTimeout:30.0 handler:nil];
  }
}

- (void)testEvaluateJavaScriptShouldSendErrorResultOnError {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  NSError *testError = [NSError errorWithDomain:@""
                                           code:1
                                       userInfo:@{NSLocalizedDescriptionKey : @"Test Error"}];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return error result over the method channel."];
  if (@available(iOS 14, *)) {
    [OCMStub([mockView callAsyncJavaScript:[OCMArg any]
                                 arguments:[OCMArg any]
                                   inFrame:[OCMArg any]
                            inContentWorld:[OCMArg any]
                         completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
      // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
      __unsafe_unretained void (^evalResultHandler)(id, NSError *);
      [invocation getArgument:&evalResultHandler atIndex:6];
      evalResultHandler(nil, testError);
    }];
  } else {
    [OCMStub([mockView evaluateJavaScript:[OCMArg any]
                        completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
      // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
      __unsafe_unretained void (^evalResultHandler)(id, NSError *);
      [invocation getArgument:&evalResultHandler atIndex:3];
      evalResultHandler(nil, testError);
    }];
  }
  controller.webView = mockView;

  // Run
  [controller onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"evaluateJavascript"
                                                             arguments:@"console.log('test')"]
                    result:^(id _Nullable result) {
                      XCTAssertTrue([result class] == [FlutterError class]);
                      [resultExpectation fulfill];
                    }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

@end
