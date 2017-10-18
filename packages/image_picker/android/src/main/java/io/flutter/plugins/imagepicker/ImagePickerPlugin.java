// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.imagepicker;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;

import com.esafirm.imagepicker.features.ImagePicker;
import com.esafirm.imagepicker.features.camera.DefaultCameraModule;
import com.esafirm.imagepicker.features.camera.OnImageReadyListener;
import com.esafirm.imagepicker.model.Image;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/** Location Plugin */
public class ImagePickerPlugin implements MethodCallHandler, ActivityResultListener {
  private static String TAG = "flutter";
  private static final String CHANNEL = "image_picker";

  public static final int REQUEST_CODE_PICK = 2342;
  public static final int REQUEST_CODE_CAMERA = 2343;

  private Activity activity;

  private static final DefaultCameraModule cameraModule = new DefaultCameraModule();

  // Pending method call to obtain an image
  private Result pendingResult;
  private MethodCall methodCall;

  public static void registerWith(PluginRegistry.Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), CHANNEL);
    final ImagePickerPlugin instance = new ImagePickerPlugin(registrar.activity());
    registrar.addActivityResultListener(instance);
    channel.setMethodCallHandler(instance);
  }

  private ImagePickerPlugin(Activity activity) {
    this.activity = activity;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (pendingResult != null) {
      result.error("ALREADY_ACTIVE", "Image picker is already active", null);
      return;
    }

    pendingResult = result;
    methodCall = call;

    if (call.method.equals("pickImage")) {
      ImagePicker.create(activity).single().start(REQUEST_CODE_PICK);
    } else if (call.method.equals("captureImage")) {
      activity.startActivityForResult(cameraModule.getCameraIntent(activity), REQUEST_CODE_CAMERA);
    } else {
      throw new IllegalArgumentException("Unknown method " + call.method);
    }
  }

  @Override
  public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    if (requestCode == REQUEST_CODE_PICK) {
      if (resultCode == Activity.RESULT_OK && data != null) {
        ArrayList<Image> images = (ArrayList<Image>) ImagePicker.getImages(data);
        handleResult(images.get(0));
      } else {
        pendingResult.error("PICK_ERROR", "Error picking image", null);
        pendingResult = null;
        methodCall = null;
      }
      return true;
    }
    if (requestCode == REQUEST_CODE_CAMERA) {
      if (resultCode == Activity.RESULT_OK && data != null)
        cameraModule.getImage(
            activity,
            data,
            new OnImageReadyListener() {
              @Override
              public void onImageReady(List<Image> images) {
                handleResult(images.get(0));
              }
            });
      return true;
    }
    return false;
  }

  private void handleResult(Image image) {
    if (pendingResult != null) {
      Double requestedWidth = methodCall.argument("width");
      Double requestedHeight = methodCall.argument("height");
      boolean shouldScale = requestedWidth != null || requestedHeight != null;

      if (!shouldScale) {
        pendingResult.success(image.getPath());
      } else {
        try {
          File imageFile = scaleImage(image, requestedWidth, requestedHeight);
          pendingResult.success(imageFile.getPath());
        } catch (IOException e) {
          throw new RuntimeException(e);
        }
      }

      pendingResult = null;
      methodCall = null;
    } else {
      throw new IllegalStateException("Received images from picker that were not requested");
    }
  }

  private File scaleImage(Image image, Double requestedWidth, Double requestedHeight) throws IOException {
    Bitmap bmp = BitmapFactory.decodeFile(image.getPath());
    int originalWidth = bmp.getWidth();
    int originalHeight = bmp.getHeight();

    int finalWidth = requestedWidth != null? requestedWidth.intValue() : originalWidth;
    int finalHeight = requestedHeight != null? requestedHeight.intValue() : originalHeight;

    Bitmap scaledBmp = Bitmap.createScaledBitmap(bmp, finalWidth, finalHeight, false);
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    scaledBmp.compress(Bitmap.CompressFormat.JPEG, 100, outputStream);

    String scaledCopyPath = image.getPath().replace(image.getName(), "scaled_" + image.getName());
    File imageFile = new File(scaledCopyPath);

    FileOutputStream fileOutput = new FileOutputStream(imageFile);
    fileOutput.write(outputStream.toByteArray());
    fileOutput.close();

    return imageFile;
  }
}
