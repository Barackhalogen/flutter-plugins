// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import file_selector_macos
import XCTest

class TestPanelController: NSObject, FLTPanelController {
  // The last panels that the relevant display methods were called on.
  public var savePanel: NSSavePanel?
  public var openPanel: NSOpenPanel?

  // Mock return values for the display methods.
  public var saveURL: URL?
  public var openURLs: [URL]?

  func display(_ panel: NSSavePanel, for window: NSWindow?, completionHandler handler: @escaping (URL?) -> Void) {
    savePanel = panel
    handler(saveURL)
  }

  func display(_ panel: NSOpenPanel, for window: NSWindow?, completionHandler handler: @escaping ([URL]?) -> Void) {
    openPanel = panel
    handler(openURLs)
  }
}

// Unused stub for TestRegistrar.
class TestMessenger: NSObject, FlutterBinaryMessenger {
  func send(onChannel channel: String, message: Data?) {}
  func send(onChannel channel: String, message: Data?, binaryReply callback: FlutterBinaryReply? = nil) {}
  func setMessageHandlerOnChannel(_ channel: String, binaryMessageHandler handler: FlutterBinaryMessageHandler? = nil) -> FlutterBinaryMessengerConnection { return 0 }
  func cleanupConnection(_ connection: FlutterBinaryMessengerConnection) {}
}

// Unused stub for TestRegistrar.
class TestTextureRegistry: NSObject, FlutterTextureRegistry {
  func register(_ texture: FlutterTexture) -> Int64 { return 0 }
  func textureFrameAvailable(_ textureId: Int64) {}
  func unregisterTexture(_ textureId: Int64) {}
}

class TestRegistrar: NSObject, FlutterPluginRegistrar {
  var view: NSView? {
    get {
      window?.contentView
    }
  }
  var window: NSWindow? = NSWindow()

  // Unused.
  var messenger: FlutterBinaryMessenger = TestMessenger()
  var textures: FlutterTextureRegistry = TestTextureRegistry()
  func addMethodCallDelegate(_ delegate: FlutterPlugin, channel: FlutterMethodChannel) {}
}

class exampleTests: XCTestCase {

  func testExample() throws {
    let plugin = FLTFileSelectorPlugin()
    XCTAssertNotNil(plugin)
  }

  func testOpenSimple() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPath = "/foo/bar"
    panelController.openURLs = [URL(fileURLWithPath: returnPath)]

    let called = XCTestExpectation()
    let call = FlutterMethodCall(methodName: "openFile", arguments: [:])
    plugin.handle(call) { result in
      XCTAssertEqual((result as! [String]?)![0], returnPath)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
    if let panel = panelController.openPanel {
      XCTAssertTrue(panel.canChooseFiles)
      // For consistency across platforms, directory selection is disabled.
      XCTAssertFalse(panel.canChooseDirectories)
    }
  }

  func testOpenWithArguments() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPath = "/foo/bar"
    panelController.openURLs = [URL(fileURLWithPath: returnPath)]

    let called = XCTestExpectation()
    let call = FlutterMethodCall(
      methodName: "openFile",
      arguments: [
        "initialDirectory": "/some/dir",
        "suggestedName": "a name",
        "confirmButtonText": "Open it!",
      ]
    )
    plugin.handle(call) { result in
      XCTAssertEqual((result as! [String]?)![0], returnPath)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
    if let panel = panelController.openPanel {
      XCTAssertEqual(panel.directoryURL?.path, "/some/dir")
      XCTAssertEqual(panel.nameFieldStringValue, "a name")
      XCTAssertEqual(panel.prompt, "Open it!")
    }
  }

  func testOpenMultiple() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPaths = ["/foo/bar", "/foo/baz"]
    panelController.openURLs = returnPaths.map({ path in URL(fileURLWithPath: path) })

    let called = XCTestExpectation()
    let call = FlutterMethodCall(
      methodName: "openFile",
      arguments: ["multiple": true]
    )
    plugin.handle(call) { result in
      let paths = (result as! [String]?)!
      XCTAssertEqual(paths.count, returnPaths.count)
      XCTAssertEqual(paths[0], returnPaths[0])
      XCTAssertEqual(paths[1], returnPaths[1])
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
  }

  func testOpenWithWildcardFilter() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPath = "/foo/bar"
    panelController.openURLs = [URL(fileURLWithPath: returnPath)]

    let called = XCTestExpectation()
    let call = FlutterMethodCall(
      methodName: "openFile",
      arguments: [
        "acceptedTypeGroups": [
          [
            "extensions": ["txt", "json"],
            "macUTIs": ["public.text"],
          ],
          [
            "macUTIs": ["public.image"],
          ],
          // An empty filter group allows anything. Since macOS doesn't support filter groups,
          // groups are unioned, so this should disable all filtering.
          [:]
        ]
      ]
    )
    plugin.handle(call) { result in
      XCTAssertEqual((result as! [String]?)![0], returnPath)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
    if let panel = panelController.openPanel {
      XCTAssertNil(panel.allowedFileTypes)
    }
  }

  func testOpenWithFilter() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPath = "/foo/bar"
    panelController.openURLs = [URL(fileURLWithPath: returnPath)]

    let called = XCTestExpectation()
    let call = FlutterMethodCall(
      methodName: "openFile",
      arguments: [
        "acceptedTypeGroups": [
          [
            "extensions": ["txt", "json"],
            "macUTIs": ["public.text"],
          ],
          [
            "macUTIs": ["public.image"],
          ],
        ]
      ]
    )
    plugin.handle(call) { result in
      XCTAssertEqual((result as! [String]?)![0], returnPath)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
    if let panel = panelController.openPanel {
      XCTAssertEqual(panel.allowedFileTypes, ["txt", "json", "public.text", "public.image"])
    }
  }

  func testOpenCancel() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let called = XCTestExpectation()
    let call = FlutterMethodCall(methodName: "openFile", arguments: [:])
    plugin.handle(call) { result in
      XCTAssertNil(result)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
  }

  func testSaveSimple() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPath = "/foo/bar"
    panelController.saveURL = URL(fileURLWithPath: returnPath)

    let called = XCTestExpectation()
    let call = FlutterMethodCall(methodName: "getSavePath", arguments: [:])
    plugin.handle(call) { result in
      XCTAssertEqual(result as! String?, returnPath)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.savePanel)
  }

  func testSaveWithArguments() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPath = "/foo/bar"
    panelController.saveURL = URL(fileURLWithPath: returnPath)

    let called = XCTestExpectation()
    let call = FlutterMethodCall(
      methodName: "getSavePath",
      arguments: [
        "initialDirectory": "/some/dir",
        "confirmButtonText": "Save it!",
      ]
    )
    plugin.handle(call) { result in
      XCTAssertEqual(result as! String?, returnPath)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.savePanel)
    if let panel = panelController.savePanel {
      XCTAssertEqual(panel.directoryURL?.path, "/some/dir")
      XCTAssertEqual(panel.prompt, "Save it!")
    }
  }

  func testSaveCancel() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let called = XCTestExpectation()
    let call = FlutterMethodCall(methodName: "getSavePath", arguments: [:])
    plugin.handle(call) { result in
      XCTAssertNil(result)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.savePanel)
  }

  func testGetDirectorySimple() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let returnPath = "/foo/bar"
    panelController.openURLs = [URL(fileURLWithPath: returnPath)]

    let called = XCTestExpectation()
    let call = FlutterMethodCall(methodName: "getDirectoryPath", arguments: [:])
    plugin.handle(call) { result in
      XCTAssertEqual(result as! String?, returnPath)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
    if let panel = panelController.openPanel {
      XCTAssertTrue(panel.canChooseDirectories)
      // For consistency across platforms, file selection is disabled.
      XCTAssertFalse(panel.canChooseFiles)
      // The Dart API only allows a single directory to be returned, so users shouldn't be allowed
      // to select multiple.
      XCTAssertFalse(panel.allowsMultipleSelection)
    }
  }

  func testGetDirectoryCancel() throws {
    let registrar = TestRegistrar()
    let panelController = TestPanelController()
    let plugin = FLTFileSelectorPlugin(registrar: registrar, panelController: panelController)

    let called = XCTestExpectation()
    let call = FlutterMethodCall(methodName: "getDirectoryPath", arguments: [:])
    plugin.handle(call) { result in
      XCTAssertNil(result)
      called.fulfill()
    }

    wait(for: [called], timeout: 0.5)
    XCTAssertNotNil(panelController.openPanel)
  }

}
