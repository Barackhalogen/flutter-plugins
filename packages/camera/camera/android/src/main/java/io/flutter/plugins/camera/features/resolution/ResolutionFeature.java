// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camera.features.resolution;

import android.os.Build;
import android.hardware.camera2.CaptureRequest;
import android.media.CamcorderProfile;
import android.media.EncoderProfiles;
import android.util.Size;
import androidx.annotation.VisibleForTesting;
import io.flutter.plugins.camera.CameraProperties;
import io.flutter.plugins.camera.features.CameraFeature;
import java.util.List;

/**
 * Controls the resolutions configuration on the {@link android.hardware.camera2} API.
 *
 * <p>The {@link ResolutionFeature} is responsible for converting the platform independent {@link
 * ResolutionPreset} into a {@link android.media.CamcorderProfile} which contains all the properties
 * required to configure the resolution using the {@link android.hardware.camera2} API.
 */
public class ResolutionFeature extends CameraFeature<ResolutionPreset> {
  private Size captureSize;
  private Size previewSize;
  private CamcorderProfile recordingProfile;
  private EncoderProfiles recordingProfile_v31;
  private ResolutionPreset currentSetting;
  private int cameraId;

  /**
   * Creates a new instance of the {@link ResolutionFeature}.
   *
   * @param cameraProperties Collection of characteristics for the current camera device.
   * @param resolutionPreset Platform agnostic enum containing resolution information.
   * @param cameraName Camera identifier of the camera for which to configure the resolution.
   */
  public ResolutionFeature(
      CameraProperties cameraProperties, ResolutionPreset resolutionPreset, String cameraName) {
    super(cameraProperties);
    this.currentSetting = resolutionPreset;
    try {
      this.cameraId = Integer.parseInt(cameraName, 10);
    } catch (NumberFormatException e) {
      this.cameraId = -1;
      return;
    }
    configureResolution(resolutionPreset, cameraId);
  }

  /**
   * Gets the {@link android.media.CamcorderProfile} containing the information to configure the
   * resolution using the {@link android.hardware.camera2} API.
   *
   * @return Resolution information to configure the {@link android.hardware.camera2} API.
   */
  public CamcorderProfile getRecordingProfile() {
    return this.recordingProfile;
  }

  public EncoderProfiles getRecordingProfile_v31() {
    return this.recordingProfile_v31;
  }

  /**
   * Gets the optimal preview size based on the configured resolution.
   *
   * @return The optimal preview size.
   */
  public Size getPreviewSize() {
    return this.previewSize;
  }

  /**
   * Gets the optimal capture size based on the configured resolution.
   *
   * @return The optimal capture size.
   */
  public Size getCaptureSize() {
    return this.captureSize;
  }

  @Override
  public String getDebugName() {
    return "ResolutionFeature";
  }

  @Override
  public ResolutionPreset getValue() {
    return currentSetting;
  }

  @Override
  public void setValue(ResolutionPreset value) {
    this.currentSetting = value;
    configureResolution(currentSetting, cameraId);
  }

  @Override
  public boolean checkIsSupported() {
    return cameraId >= 0;
  }

  @Override
  public void updateBuilder(CaptureRequest.Builder requestBuilder) {
    // No-op: when setting a resolution there is no need to update the request builder.
  }

  @SuppressWarnings("deprecation")
  @VisibleForTesting
  static Size computeBestPreviewSize(int cameraId, ResolutionPreset preset) {
    if (preset.ordinal() > ResolutionPreset.high.ordinal()) {
      preset = ResolutionPreset.high;
    }
    if (Build.VERSION.SDK_INT >= 31) {
      EncoderProfiles profile = getBestAvailableCamcorderProfileForResolutionPreset_v31(cameraId, preset);
      List<EncoderProfiles.VideoProfile> videoProfiles = profile.getVideoProfiles();
      
      try {
        EncoderProfiles.VideoProfile defaultVideoProfile = videoProfiles.get(0);
        return new Size(defaultVideoProfile.getWidth(), defaultVideoProfile.getHeight());
      }
      catch (IndexOutOfBoundsException e) {
        System.out.println("No video profiles found.");
        return null;
      }
    }
    else {
      CamcorderProfile profile =
      getBestAvailableCamcorderProfileForResolutionPreset(cameraId, preset);
      return new Size(profile.videoFrameWidth, profile.videoFrameHeight);
    }
  }

  /**
   * Gets the best possible {@link android.media.CamcorderProfile} for the supplied {@link
   * ResolutionPreset}.
   *
   * @param cameraId Camera identifier which indicates the device's camera for which to select a
   *     {@link android.media.CamcorderProfile}.
   * @param preset The {@link ResolutionPreset} for which is to be translated to a {@link
   *     android.media.CamcorderProfile}.
   * @return The best possible {@link android.media.CamcorderProfile} that matches the supplied
   *     {@link ResolutionPreset}.
   */
  @SuppressWarnings("deprecation")
  public static CamcorderProfile getBestAvailableCamcorderProfileForResolutionPreset(
      int cameraId, ResolutionPreset preset) {
    if (cameraId < 0) {
      throw new AssertionError(
          "getBestAvailableCamcorderProfileForResolutionPreset can only be used with valid (>=0) camera identifiers.");
    }

    switch (preset) {
        // All of these cases deliberately fall through to get the best available profile.
      case max:
        if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_HIGH)) {
          return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_HIGH);
        }
      case ultraHigh:
        if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_2160P)) {
          return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_2160P);
        }
      case veryHigh:
        if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_1080P)) {
          return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_1080P);
        }
      case high:
        if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_720P)) {
          return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_720P);
        }
      case medium:
        if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_480P)) {
          return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_480P);
        }
      case low:
        if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_QVGA)) {
          return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_QVGA);
        }
      default:
        if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_LOW)) {
          return CamcorderProfile.get(cameraId, CamcorderProfile.QUALITY_LOW);
        } else {
          throw new IllegalArgumentException(
              "No capture session available for current capture session.");
        }
    }
  }

  public static EncoderProfiles getBestAvailableCamcorderProfileForResolutionPreset_v31(
    int cameraId, ResolutionPreset preset) {
  if (cameraId < 0) {
    throw new AssertionError(
        "getBestAvailableCamcorderProfileForResolutionPreset can only be used with valid (>=0) camera identifiers.");
  }

  String cameraIdString = Integer.toString(cameraId);

  switch (preset) {
      // All of these cases deliberately fall through to get the best available profile.
    case max:
      if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_HIGH)) {
        return CamcorderProfile.getAll(cameraIdString, CamcorderProfile.QUALITY_HIGH);
      }
    case ultraHigh:
      if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_2160P)) {
        return CamcorderProfile.getAll(cameraIdString, CamcorderProfile.QUALITY_2160P);
      }
    case veryHigh:
      if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_1080P)) {
        return CamcorderProfile.getAll(cameraIdString, CamcorderProfile.QUALITY_1080P);
      }
    case high:
      if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_720P)) {
        return CamcorderProfile.getAll(cameraIdString, CamcorderProfile.QUALITY_720P);
      }
    case medium:
      if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_480P)) {
        return CamcorderProfile.getAll(cameraIdString, CamcorderProfile.QUALITY_480P);
      }
    case low:
      if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_QVGA)) {
        return CamcorderProfile.getAll(cameraIdString, CamcorderProfile.QUALITY_QVGA);
      }
    default:
      if (CamcorderProfile.hasProfile(cameraId, CamcorderProfile.QUALITY_LOW)) {
        return CamcorderProfile.getAll(cameraIdString, CamcorderProfile.QUALITY_LOW);
      } else {
        throw new IllegalArgumentException(
            "No capture session available for current capture session.");
      }
  }
}

  @SuppressWarnings("deprecation")
  private void configureResolution(ResolutionPreset resolutionPreset, int cameraId) {
    if (!checkIsSupported()) {
      return;
    }

    if (Build.VERSION.SDK_INT >= 31) {
      System.out.println("31");
      recordingProfile_v31 =
      getBestAvailableCamcorderProfileForResolutionPreset_v31(cameraId, resolutionPreset);
      List<EncoderProfiles.VideoProfile> videoProfiles =  recordingProfile_v31.getVideoProfiles();

      try {
        EncoderProfiles.VideoProfile defaultVideoProfile = videoProfiles.get(0);
        captureSize = new Size(defaultVideoProfile.getWidth(), defaultVideoProfile.getHeight());
      }
      catch (IndexOutOfBoundsException e) {
        System.out.println("No video profiles found.");
      }
    }
    else {
      System.out.println("not 31");
      recordingProfile =
          getBestAvailableCamcorderProfileForResolutionPreset(cameraId, resolutionPreset);
      captureSize = new Size(recordingProfile.videoFrameWidth, recordingProfile.videoFrameHeight);
    }

    previewSize = computeBestPreviewSize(cameraId, resolutionPreset);
  }
}
