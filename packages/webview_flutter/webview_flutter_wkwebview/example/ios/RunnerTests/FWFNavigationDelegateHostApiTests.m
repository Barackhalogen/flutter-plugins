// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

@import Flutter;
@import XCTest;
@import webview_flutter_wkwebview;

#import <OCMock/OCMock.h>

@interface FWFNavigationDelegateHostApiTests : XCTestCase
@end

@implementation FWFNavigationDelegateHostApiTests
- (void)testCreateWithIdentifier {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFNavigationDelegateHostApiImpl *hostApi = [[FWFNavigationDelegateHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostApi createWithIdentifier:@0 didFinishNavigationIdentifier:nil error:&error];
  FWFNavigationDelegate *navigationDelegate =
      (FWFNavigationDelegate *)[instanceManager instanceForIdentifier:0];

  XCTAssertTrue([navigationDelegate conformsToProtocol:@protocol(WKNavigationDelegate)]);
  XCTAssertNil(error);
}

- (void)testDidFinishNavigation {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFNavigationDelegateHostApiImpl *hostApi = [[FWFNavigationDelegateHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostApi createWithIdentifier:@0 didFinishNavigationIdentifier:@1 error:&error];
  FWFNavigationDelegate *navigationDelegate =
      (FWFNavigationDelegate *)[instanceManager instanceForIdentifier:0];
  id mockDelegate = OCMPartialMock(navigationDelegate);

  FWFNavigationDelegateFlutterApiImpl *flutterApi = [[FWFNavigationDelegateFlutterApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];
  id mockFlutterApi = OCMPartialMock(flutterApi);

  OCMStub([mockDelegate navigationDelegateApi]).andReturn(mockFlutterApi);

  WKWebView *mockWebView = OCMClassMock([WKWebView class]);
  OCMStub([mockWebView URL]).andReturn([NSURL URLWithString:@"https://flutter.dev/"]);
  [instanceManager addInstance:mockWebView withIdentifier:2];

  [mockDelegate webView:mockWebView didFinishNavigation:OCMClassMock([WKNavigation class])];
  OCMVerify([mockFlutterApi didFinishNavigationFunctionWithIdentifier:@1
                                                    webViewIdentifier:@2
                                                                  URL:@"https://flutter.dev/"
                                                           completion:OCMOCK_ANY]);
}

- (void)testInstanceCanBeReleasedWhenInstanceManagerIsReleased {
  FWFInstanceManager *instanceManager = [[FWFInstanceManager alloc] init];
  FWFNavigationDelegateHostApiImpl *hostApi = [[FWFNavigationDelegateHostApiImpl alloc]
      initWithBinaryMessenger:OCMProtocolMock(@protocol(FlutterBinaryMessenger))
              instanceManager:instanceManager];

  FlutterError *error;
  [hostApi createWithIdentifier:@0 didFinishNavigationIdentifier:nil error:&error];
  FWFNavigationDelegate __weak *navigationDelegate =
      (FWFNavigationDelegate *)[instanceManager instanceForIdentifier:0];

  XCTAssertNotNil(navigationDelegate);
  instanceManager = nil;
  XCTAssertNil(navigationDelegate);
}
@end
