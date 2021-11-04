// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import FlutterMacOS
import XCTest
import url_launcher_macos

class StubWorkspace: SystemURLHandler {

  var isSuccessful = true

  func open(_ url: URL) -> Bool {
    return isSuccessful
  }

  func urlForApplication(toOpen: URL) -> URL? {
      return toOpen
  }
}

class RunnerTests: XCTestCase {

  func testNoHandlerReturnsFlutterMethodNotImplemented() throws {
    let plugin = UrlLauncherPlugin()

    let call = FlutterMethodCall(
      methodName: "noHandler",
      arguments: ["url": "https://flutter.dev"])

    plugin.handle(
      call,
      result: { (result: Any?) -> Void in
        XCTAssertEqual(result as? NSObject, FlutterMethodNotImplemented)
      })
  }

  func testCanLaunchSuccessReturnsTrue() throws {
    let plugin = UrlLauncherPlugin()

    let call = FlutterMethodCall(
      methodName: "canLaunch",
      arguments: ["url": "https://flutter.dev"])

    plugin.handle(
      call,
      result: { (result: Any?) -> Void in
        XCTAssertEqual(result as? Bool, true)
      })
  }

  func testCanLaunchFailureReturnsFalse() throws {
    let plugin = UrlLauncherPlugin()

    let call = FlutterMethodCall(
      methodName: "canLaunch",
      arguments: ["url": "brokenUrl"])

    plugin.handle(
      call,
      result: { (result: Any?) -> Void in
        XCTAssertEqual(result as? Bool, false)
      })
  }

  func testCanLaunchMissingArgumentReturnsFlutterError() throws {
    let plugin = UrlLauncherPlugin()

    let call = FlutterMethodCall(
      methodName: "canLaunch",
      arguments: [])

    plugin.handle(
      call,
      result: { (result: Any?) -> Void in
        XCTAssertTrue(result! is FlutterError)
      })
  }

  func testLaunchSuccessReturnsTrue() throws {
    let workspace = StubWorkspace()
    let pluginWithStubWorkspace = UrlLauncherPlugin(workspace)

    let call = FlutterMethodCall(
      methodName: "launch",
      arguments: ["url": "https://flutter.dev"])

    pluginWithStubWorkspace.handle(
      call,
      result: { (result: Any?) -> Void in
          XCTAssertEqual(result as? Bool, true)
      })
  }

  func testLaunchMissingArgumentReturnsFlutterError() throws {
    let workspace = StubWorkspace()
    let pluginWithStubWorkspace = UrlLauncherPlugin(workspace)

    let call = FlutterMethodCall(
      methodName: "canLaunch",
      arguments: [])

    pluginWithStubWorkspace.handle(
      call,
      result: { (result: Any?) -> Void in
        XCTAssertTrue(result! is FlutterError)
      })
  }
}
