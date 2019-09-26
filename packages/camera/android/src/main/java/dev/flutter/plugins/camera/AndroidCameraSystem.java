// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package dev.flutter.plugins.camera;

import android.content.Context;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraManager;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.EventChannel;
import io.flutter.view.TextureRegistry;

/**
 * Android implementation of a {@link CameraSystem}.
 */
/* package */ class AndroidCameraSystem implements CameraSystem {
  @NonNull
  private final FlutterPlugin.FlutterPluginBinding pluginBinding;
  @NonNull
  private final ActivityPluginBinding activityBinding;
  @NonNull
  private final CameraPermissions cameraPermissions;
  @NonNull
  private final CameraPreviewDisplay cameraPreviewDisplay;
  @NonNull
  private final CameraPluginProtocol.CameraEventChannelFactory cameraEventChannelFactory;
  @Nullable
  private Camera camera;

  /* package */ AndroidCameraSystem(
      @NonNull FlutterPlugin.FlutterPluginBinding pluginBinding,
      @NonNull ActivityPluginBinding activityBinding,
      @NonNull CameraPermissions cameraPermissions,
      @NonNull CameraPreviewDisplay cameraPreviewDisplay,
      @NonNull CameraPluginProtocol.CameraEventChannelFactory cameraEventChannelFactory
      ) {
    this.pluginBinding = pluginBinding;
    this.activityBinding = activityBinding;
    this.cameraPermissions = cameraPermissions;
    this.cameraPreviewDisplay = cameraPreviewDisplay;
    this.cameraEventChannelFactory = cameraEventChannelFactory;
  }

  @Override
  public List<CameraDetails> getAvailableCameras() throws CameraAccessException {
    List<Map<String, Object>> allCameraDetailsSerialized = CameraUtils.getAvailableCameras(activityBinding.getActivity());
    List<CameraDetails> allCameraDetails = new ArrayList<>();
    for (Map<String, Object> serializedDetails : allCameraDetailsSerialized) {
      allCameraDetails.add(new CameraDetails(
          (String) serializedDetails.get("name"),
          (Integer) serializedDetails.get("sensorOrientation"),
          (String) serializedDetails.get("lensFacing")
      ));
    }
    return allCameraDetails;
  }

  @Override
  public void initialize(
      @NonNull CameraConfigurationRequest request,
      @NonNull OnCameraInitializationCallback callback
  ) {
    if (camera != null) {
      camera.close();
    }

    cameraPermissions.requestPermissions(
        request.getEnableAudio(),
        new CameraPermissions.ResultCallback() {
          @Override
          public void onSuccess() {
            try {
              instantiateCamera(request, callback);
            } catch (Exception error) {
              callback.onError("CameraAccess", error.getMessage());
            }
          }

          @Override
          public void onResult(String errorCode, String errorDescription) {
            callback.onCameraPermissionError(errorCode, errorDescription);
          }
        });
  }

  private void instantiateCamera(
      @NonNull CameraConfigurationRequest request,
      @NonNull OnCameraInitializationCallback callback
  ) throws CameraAccessException {
    TextureRegistry.SurfaceTextureEntry textureEntry = pluginBinding
        .getFlutterEngine()
        .getRenderer()
        .createSurfaceTexture();

    camera = new Camera(
        activityBinding.getActivity(),
        (CameraManager) activityBinding.getActivity().getSystemService(Context.CAMERA_SERVICE),
        textureEntry,
        request.getCameraName(),
        request.getResolutionPreset(),
        request.getEnableAudio()
    );

    camera.open(new Camera.OnCameraOpenedCallback() {
      @Override
      public void onCameraOpened(long textureId, int previewWidth, int previewHeight) {
        callback.onSuccess(textureId, previewWidth, previewHeight);
      }

      @Override
      public void onCameraOpenFailed(@NonNull String message) {
        callback.onError("CameraAccess", message);
      }
    });

    final CameraPluginProtocol.ChannelCameraEventHandler eventHandler = new CameraPluginProtocol.ChannelCameraEventHandler();
    camera.setCameraEventHandler(eventHandler);

    EventChannel cameraEventChannel = cameraEventChannelFactory.createCameraEventChannel(textureEntry.id());
    cameraEventChannel.setStreamHandler(new EventChannel.StreamHandler() {
      @Override
      public void onListen(Object o, final EventChannel.EventSink eventSink) {
        eventHandler.setEventSink(eventSink);
      }

      @Override
      public void onCancel(Object o) {
        eventHandler.setEventSink(null);
      }
    });
  }

  @Override
  public void takePicture(@NonNull String filePath, @NonNull Camera.OnPictureTakenCallback callback) {
    // TODO(mattcarroll): determine desired behavior when no camera is active
    camera.takePicture(filePath, callback);
  }

  @Override
  public void startVideoRecording(@NonNull String filePath, @NonNull OnStartVideoRecordingCallback callback) {
    // TODO(mattcarroll): determine desired behavior when no camera is active
    try {
      camera.startVideoRecording(filePath);
    } catch (IllegalStateException e) {
      callback.onFileAlreadyExists(filePath);
    } catch (CameraAccessException | IOException e) {
      callback.onVideoRecordingFailed(e.getMessage());
    }
  }

  @Override
  public void stopVideoRecording(@NonNull OnVideoRecordingCommandCallback callback) {
    // TODO(mattcarroll): determine desired behavior when no camera is active
    try {
      camera.stopVideoRecording();
      callback.success();
    } catch (CameraAccessException | IllegalStateException e) {
      callback.onVideoRecordingFailed(e.getMessage());
    }
  }

  @Override
  public void pauseVideoRecording(@NonNull OnApiDependentVideoRecordingCommandCallback callback) {
    // TODO(mattcarroll): determine desired behavior when no camera is active
    try {
      camera.pauseVideoRecording();
    } catch (UnsupportedOperationException e) {
      callback.onUnsupportedOperation();
    } catch (IllegalStateException e) {
      callback.onVideoRecordingFailed(e.getMessage());
    }
  }

  @Override
  public void resumeVideoRecording(@NonNull OnApiDependentVideoRecordingCommandCallback callback) {
    // TODO(mattcarroll): determine desired behavior when no camera is active
    try {
      camera.resumeVideoRecording();
    } catch (UnsupportedOperationException e) {
      callback.onUnsupportedOperation();
    } catch (IllegalStateException e) {
      callback.onVideoRecordingFailed(e.getMessage());
    }
  }

  @Override
  public void startImageStream(@NonNull OnCameraAccessCommandCallback callback) {
    // TODO(mattcarroll): determine desired behavior when no camera is active
    try {
      camera.startPreviewWithImageStream(cameraPreviewDisplay);
      callback.success();
    } catch (CameraAccessException e) {
      callback.onCameraAccessFailure(e.getMessage());
    }
  }

  @Override
  public void stopImageStream(@NonNull OnCameraAccessCommandCallback callback) {
    // TODO(mattcarroll): determine desired behavior when no camera is active
    try {
      camera.startPreview();
      callback.success();
    } catch (CameraAccessException e) {
      callback.onCameraAccessFailure(e.getMessage());
    }
  }

  @Override
  public void dispose() {
    if (camera != null) {
      camera.dispose();
    }
  }
}
