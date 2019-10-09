// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.webviewflutter;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Java platform implementation of the webview_flutter plugin.
 *
 * <p>Instantiate this in an add to app scenario to gracefully handle activity and context changes.
 *
 * <p>Call registerWith to use the stable {@code io.flutter.plugin.common} package instead.
 */
public class WebViewFlutterPlugin implements FlutterPlugin {
  private @Nullable FlutterCookieManager flutterCookieManager;

  /**
   * Initialize this within the {@code #configureFlutterEngine} of a Flutter activity or fragment.
   *
   * <p>See {@code io.flutter.plugins.webviewflutterexample.MainActivity} for an example.
   */
  public WebViewFlutterPlugin() {}

  /**
   * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
   * package.
   *
   * <p>Calling this automatically initializes the plugin. However plugins initialized this way
   * won't react to changes in activity or context, unlike {@link CameraPlugin}.
   */
  public static void registerWith(Registrar registrar) {
    registrar
        .platformViewRegistry()
        .registerViewFactory(
            "plugins.flutter.io/webview",
            new WebViewFactory(registrar.messenger(), registrar.view()));
    FlutterCookieManager.registerWith(registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    BinaryMessenger messenger = binding.getFlutterEngine().getDartExecutor();
    binding
        .getFlutterEngine()
        .getPlatformViewsController()
        .getRegistry()
        .registerViewFactory(
            "plugins.flutter.io/webview", new WebViewFactory(messenger, /*containerView=*/ null));
    flutterCookieManager = new FlutterCookieManager(messenger);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (flutterCookieManager == null) {
      return;
    }

    flutterCookieManager.dispose();
    flutterCookieManager = null;
  }
}
