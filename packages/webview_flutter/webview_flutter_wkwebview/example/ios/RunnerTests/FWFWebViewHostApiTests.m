// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@import Flutter;
@import XCTest;
@import webview_flutter_wkwebview;

#import <OCMock/OCMock.h>

@interface FWFWebViewHostApiTests : XCTestCase
@end

@implementation FWFWebViewHostApiTests
- (void)testLoadRequest {
  FWFWebView *mockWebView = OCMClassMock(FWFWebView.class);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addInstance:mockWebView withIdentifier:0];

  FWFWebViewHostApiImpl *hostApi =
      [[FWFWebViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  FWFNSUrlRequestData *requestData = [FWFNSUrlRequestData makeWithUrl:@"https://www.flutter.dev"
                                                           httpMethod:@"get"
                                                             httpBody:nil
                                                  allHttpHeaderFields:@{@"a" : @"header"}];
  [hostApi webView:@(0) loadRequest:requestData error:&error];

  NSURL *url = [NSURL URLWithString:@"https://www.flutter.dev"];
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"get";
  request.allHTTPHeaderFields = @{@"a" : @"header"};
  OCMVerify([mockWebView loadRequest:request]);
  XCTAssertNil(error);
}

- (void)testSetCustomUserAgent {
  FWFWebView *mockWebView = OCMClassMock(FWFWebView.class);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addInstance:mockWebView withIdentifier:0];

  FWFWebViewHostApiImpl *hostApi =
      [[FWFWebViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  [hostApi webView:@(0) setCustomUserAgent:@"userA" error:&error];
  OCMVerify([mockWebView setCustomUserAgent:@"userA"]);
  XCTAssertNil(error);
}

- (void)testUrl {
  FWFWebView *mockWebView = OCMClassMock(FWFWebView.class);
  OCMStub([mockWebView URL]).andReturn([NSURL URLWithString:@"https://www.flutter.dev/"]);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addInstance:mockWebView withIdentifier:0];

  FWFWebViewHostApiImpl *hostApi =
      [[FWFWebViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  XCTAssertEqualObjects([hostApi webViewUrl:@(0) error:&error], @"https://www.flutter.dev/");
  XCTAssertNil(error);
}

- (void)testCanGoBack {
  FWFWebView *mockWebView = OCMClassMock(FWFWebView.class);
  OCMStub([mockWebView canGoBack]).andReturn(YES);

  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  [instanceManager addInstance:mockWebView withIdentifier:0];

  FWFWebViewHostApiImpl *hostApi =
      [[FWFWebViewHostApiImpl alloc] initWithInstanceManager:instanceManager];

  FlutterError *error;
  XCTAssertEqualObjects([hostApi webViewCanGoBack:@(0) error:&error], @YES);
  XCTAssertNil(error);
}
@end
