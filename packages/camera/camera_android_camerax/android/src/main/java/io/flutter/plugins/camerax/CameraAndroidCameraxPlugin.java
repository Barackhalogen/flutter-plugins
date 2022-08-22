// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camerax;

import android.content.Context;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;

/** CameraAndroidCameraxPlugin */
public final class CameraAndroidCameraxPlugin implements FlutterPlugin, ActivityAware {
  private InstanceManager instanceManager;

  /**
   * Initialize this within the {@code #configureFlutterEngine} of a Flutter activity or fragment.
   *
   * <p>See {@code io.flutter.plugins.camera.MainActivity} for an example.
   */
  public CameraAndroidCameraxPlugin() {}

  /**
   * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
   * package.
   *
   * <p>Calling this automatically initializes the plugin. However plugins initialized this way
   * won't react to changes in activity or context, unlike {@link CameraPlugin}.
   */
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    System.out.println("REGISTERED!!!!!!!!!!!!!!!!!!!!!!!!!!2");
    (new CameraAndroidCameraxPlugin()).setUp(registrar.messenger(), registrar.activeContext());
  }

  void setUp(BinaryMessenger binaryMessenger, Context context) {
    // Set up instance manager.
    instanceManager = InstanceManager.open(identifier -> {});

    // Set up Host APIs.
    GeneratedCameraXLibrary.ProcessCameraProviderHostApi.setup(
        binaryMessenger,
        new ProcessCameraProviderHostApiImpl(
            binaryMessenger,
            instanceManager,
            context));
    GeneratedCameraXLibrary.CameraInfoHostApi.setup(
        binaryMessenger, new CameraInfoHostApiImpl(instanceManager));
    GeneratedCameraXLibrary.CameraSelectorHostApi.setup(
        binaryMessenger,
        new CameraSelectorHostApiImpl(
            binaryMessenger,
            instanceManager));
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    System.out.println("ATTACHED!!!!!!");
    (new CameraAndroidCameraxPlugin())
        .setUp(
            flutterPluginBinding.getBinaryMessenger(),
            flutterPluginBinding.getApplicationContext());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    instanceManager.close();
  }

  // Activity Lifecycle methods:

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding activityPluginBinding) {
    System.out.println("ATTACHED TO ACTIVITY!");
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {}

  @Override
  public void onReattachedToActivityForConfigChanges(
      @NonNull ActivityPluginBinding activityPluginBinding) {}

  @Override
  public void onDetachedFromActivity() {}
}
