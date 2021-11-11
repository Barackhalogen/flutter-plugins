// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@import Flutter;
@import XCTest;
@import webview_flutter_wkwebview;
@import webview_flutter_wkwebview.Test;

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

- (void)testRunJavascriptFailsForNullString {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return error result over the method channel."];

  // Run
  [controller onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"runJavascript"
                                                             arguments:nil]
                    result:^(id _Nullable result) {
                      XCTAssertTrue([result class] == [FlutterError class]);
                      [resultExpectation fulfill];
                    }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testRunJavascriptRunsStringWithSuccessResult {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return successful result over the method channel."];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  [OCMStub([mockView evaluateJavaScript:[OCMArg any]
                      completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
    // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
    __unsafe_unretained void (^evalResultHandler)(id, NSError *);
    [invocation getArgument:&evalResultHandler atIndex:3];
    evalResultHandler(@"RESULT", nil);
  }];
  controller.webView = mockView;

  // Run
  [controller onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"runJavascript"
                                                             arguments:@"Test JavaScript String"]
                    result:^(id _Nullable result) {
                      XCTAssertNil(result);
                      [resultExpectation fulfill];
                    }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testRunJavascriptReturnsErrorResultForWKError {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return error result over the method channel."];
  NSError *testError =
      [NSError errorWithDomain:@""
                          // Any error code but WKErrorJavascriptResultTypeIsUnsupported
                          code:WKErrorJavaScriptResultTypeIsUnsupported + 1
                      userInfo:@{NSLocalizedDescriptionKey : @"Test Error"}];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  [OCMStub([mockView evaluateJavaScript:[OCMArg any]
                      completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
    // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
    __unsafe_unretained void (^evalResultHandler)(id, NSError *);
    [invocation getArgument:&evalResultHandler atIndex:3];
    evalResultHandler(nil, testError);
  }];
  controller.webView = mockView;

  // Run
  [controller onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"runJavascript"
                                                             arguments:@"Test JavaScript String"]
                    result:^(id _Nullable result) {
                      XCTAssertTrue([result class] == [FlutterError class]);
                      [resultExpectation fulfill];
                    }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testRunJavascriptReturnsSuccessForWKErrorJavascriptResultTypeIsUnsupported {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return nil result over the method channel."];
  NSError *testError = [NSError errorWithDomain:@""
                                           code:WKErrorJavaScriptResultTypeIsUnsupported
                                       userInfo:@{NSLocalizedDescriptionKey : @"Test Error"}];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  [OCMStub([mockView evaluateJavaScript:[OCMArg any]
                      completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
    // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
    __unsafe_unretained void (^evalResultHandler)(id, NSError *);
    [invocation getArgument:&evalResultHandler atIndex:3];
    evalResultHandler(nil, testError);
  }];
  controller.webView = mockView;

  // Run
  [controller onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"runJavascript"
                                                             arguments:@"Test JavaScript String"]
                    result:^(id _Nullable result) {
                      XCTAssertNil(result);
                      [resultExpectation fulfill];
                    }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testRunJavascriptReturningResultFailsForNullString {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return error result over the method channel."];

  // Run
  [controller
      onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"runJavascriptReturningResult"
                                                     arguments:nil]
            result:^(id _Nullable result) {
              XCTAssertTrue([result class] == [FlutterError class]);
              [resultExpectation fulfill];
            }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testRunJavascriptReturningResultRunsStringWithSuccessResult {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return successful result over the method channel."];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  [OCMStub([mockView evaluateJavaScript:[OCMArg any]
                      completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
    // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
    __unsafe_unretained void (^evalResultHandler)(id, NSError *);
    [invocation getArgument:&evalResultHandler atIndex:3];
    evalResultHandler(@"RESULT", nil);
  }];
  controller.webView = mockView;

  // Run
  [controller
      onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"runJavascriptReturningResult"
                                                     arguments:@"Test JavaScript String"]
            result:^(id _Nullable result) {
              XCTAssertTrue([@"RESULT" isEqualToString:result]);
              [resultExpectation fulfill];
            }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testBuildNSURLRequestReturnsNilForNonDictionaryValue {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];

  // Run
  NSURLRequest *request = [controller buildNSURLRequest:@{@"request" : @"Non Dictionary Value"}];

  // Verify
  XCTAssertNil(request);
}

- (void)testBuildNSURLRequestReturnsNilForMissingURI {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];

  // Run
  NSURLRequest *request = [controller buildNSURLRequest:@{@"request" : @{}}];

  // Verify
  XCTAssertNil(request);
}

- (void)testBuildNSURLRequestReturnsNilForInvalidURI {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];

  // Run
  NSDictionary *requestData = @{@"uri" : @"invalid uri"};
  NSURLRequest *request = [controller buildNSURLRequest:@{@"request" : requestData}];

  // Verify
  XCTAssertNil(request);
}

- (void)testBuildNSURLRequestBuildsNSMutableURLRequestWithOptionalParameters {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];

  // Run
  NSDictionary *requestData = @{
    @"uri" : @"https://flutter.dev",
    @"method" : @"POST",
    @"headers" : @{@"Foo" : @"Bar"},
    @"body" : [FlutterStandardTypedData
        typedDataWithBytes:[@"Test Data" dataUsingEncoding:NSUTF8StringEncoding]],
  };
  NSURLRequest *request = [controller buildNSURLRequest:@{@"request" : requestData}];

  // Verify
  XCTAssertNotNil(request);
  XCTAssertEqualObjects(request.URL.absoluteString, @"https://flutter.dev");
  XCTAssertEqualObjects(request.HTTPMethod, @"POST");
  XCTAssertEqualObjects(request.allHTTPHeaderFields, @{@"Foo" : @"Bar"});
  XCTAssertEqualObjects(request.HTTPBody, [@"Test Data" dataUsingEncoding:NSUTF8StringEncoding]);
}

- (void)testBuildNSURLRequestBuildsNSMutableURLRequestWithoutOptionalParameters {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];

  // Run
  NSDictionary *requestData = @{
    @"uri" : @"https://flutter.dev",
  };
  NSURLRequest *request = [controller buildNSURLRequest:@{@"request" : requestData}];

  // Verify
  XCTAssertNotNil(request);
  XCTAssertEqualObjects(request.URL.absoluteString, @"https://flutter.dev");
  XCTAssertEqualObjects(request.HTTPMethod, @"GET");
  XCTAssertNil(request.allHTTPHeaderFields);
  XCTAssertNil(request.HTTPBody);
}

- (void)testOnLoadUrlReturnsErrorResultForInvalidRequest {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return error result when request cannot be built"];

  // Run
  FlutterMethodCall *methodCall = [FlutterMethodCall methodCallWithMethodName:@"loadUrl"
                                                                    arguments:@{}];
  [controller onLoadUrl:methodCall
                 result:^(id _Nullable result) {
                   XCTAssertTrue([result class] == [FlutterError class]);
                   [resultExpectation fulfill];
                 }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testOnLoadUrlLoadsRequestWithSuccessResult {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Should return nil"];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  controller.webView = mockView;

  // Run
  FlutterMethodCall *methodCall =
      [FlutterMethodCall methodCallWithMethodName:@"loadUrl"
                                        arguments:@{@"url" : @"https://flutter.dev/"}];
  [controller onLoadUrl:methodCall
                 result:^(id _Nullable result) {
                   XCTAssertNil(result);
                   [resultExpectation fulfill];
                 }];

  // Verify
  OCMVerify([mockView loadRequest:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testOnLoadRequestReturnsErroResultForInvalidRequest {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return error result when request cannot be built"];

  // Run
  FlutterMethodCall *methodCall = [FlutterMethodCall methodCallWithMethodName:@"loadRequest"
                                                                    arguments:@{}];
  [controller onLoadRequest:methodCall
                     result:^(id _Nullable result) {
                       XCTAssertTrue([result class] == [FlutterError class]);
                       [resultExpectation fulfill];
                     }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testOnLoadRequestLoadsRequestWithSuccessResult {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation = [self expectationWithDescription:@"Should return nil"];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  controller.webView = mockView;

  // Run
  FlutterMethodCall *methodCall = [FlutterMethodCall
      methodCallWithMethodName:@"loadRequest"
                     arguments:@{@"request" : @{@"uri" : @"https://flutter.dev/"}}];
  [controller onLoadRequest:methodCall
                     result:^(id _Nullable result) {
                       XCTAssertNil(result);
                       [resultExpectation fulfill];
                     }];

  // Verify
  OCMVerify([mockView loadRequest:[OCMArg any]]);
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testRunJavascriptReturningResultReturnsErrorResultForWKError {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should return error result over the method channel."];
  NSError *testError = [NSError errorWithDomain:@""
                                           code:5
                                       userInfo:@{NSLocalizedDescriptionKey : @"Test Error"}];
  FLTWKWebView *mockView = OCMClassMock(FLTWKWebView.class);
  [OCMStub([mockView evaluateJavaScript:[OCMArg any]
                      completionHandler:[OCMArg any]]) andDo:^(NSInvocation *invocation) {
    // __unsafe_unretained: https://github.com/erikdoe/ocmock/issues/384#issuecomment-589376668
    __unsafe_unretained void (^evalResultHandler)(id, NSError *);
    [invocation getArgument:&evalResultHandler atIndex:3];
    evalResultHandler(nil, testError);
  }];
  controller.webView = mockView;

  // Run
  [controller
      onMethodCall:[FlutterMethodCall methodCallWithMethodName:@"runJavascriptReturningResult"
                                                     arguments:@"Test JavaScript String"]
            result:^(id _Nullable result) {
              XCTAssertTrue([result class] == [FlutterError class]);
              [resultExpectation fulfill];
            }];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLimitsNavigationsToAppBoundDomainsDefaultToFalse {
  // Setup
  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:nil
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should set limitsNavigationsToAppBoundDomains to false"];

  // Run
  if (@available(iOS 14.0, *)) {
    XCTAssertFalse(controller.webView.configuration.limitsNavigationsToAppBoundDomains);
  }

  [resultExpectation fulfill];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

- (void)testLimitsNavigationsToAppBoundDomainsSetToTrue {
  // Setup
  NSDictionary *arguments = @{@"limitsNavigationsToAppBoundDomains" : @true};

  FLTWebViewController *controller =
      [[FLTWebViewController alloc] initWithFrame:CGRectMake(0, 0, 300, 400)
                                   viewIdentifier:1
                                        arguments:arguments
                                  binaryMessenger:self.mockBinaryMessenger];
  XCTestExpectation *resultExpectation =
      [self expectationWithDescription:@"Should set limitsNavigationsToAppBoundDomains to true"];

  // Run
  if (@available(iOS 14.0, *)) {
    XCTAssertTrue(controller.webView.configuration.limitsNavigationsToAppBoundDomains);
  }

  [resultExpectation fulfill];

  // Verify
  [self waitForExpectationsWithTimeout:30.0 handler:nil];
}

@end
