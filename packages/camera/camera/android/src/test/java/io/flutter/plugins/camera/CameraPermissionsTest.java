// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camera;

import static junit.framework.TestCase.assertEquals;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.verify;

import android.content.pm.PackageManager;
import io.flutter.plugins.camera.CameraPermissions.CameraRequestPermissionsListener;
import org.junit.Test;

public class CameraPermissionsTest {
  @Test
  public void listener_respondsOnce() {
    final int[] calledCounter = {0};
    CameraRequestPermissionsListener permissionsListener =
        new CameraRequestPermissionsListener((String code, String desc) -> calledCounter[0]++);

    permissionsListener.onRequestPermissionsResult(
        9796, null, new int[] {PackageManager.PERMISSION_DENIED});
    permissionsListener.onRequestPermissionsResult(
        9796, null, new int[] {PackageManager.PERMISSION_GRANTED});

    assertEquals(1, calledCounter[0]);
  }

  @Test
  public void callback_respondsWithCameraAccessDenied() {
    ResultCallback callback = mock (ResultCallback.class);
    CameraRequestPermissionsListener permissionsListener =
        new CameraRequestPermissionsListener(callback);

    permissionsListener.onRequestPermissionsResult(
      9796, null, new int[] {PackageManager.PERMISSION_DENIED});

    verify(callback).onResult("CameraAccessDenied", "Camera access permission was denied.");
  }

  @Test
  public void callback_respondsWithAudioAccessDenied() {
    ResultCallback callback = mock (ResultCallback.class);
    CameraRequestPermissionsListener permissionsListener =
        new CameraRequestPermissionsListener(callback);

    permissionsListener.onRequestPermissionsResult(
      9796, null, new int[] {PackageManager.GRANTED, PackageManager.PERMISSION_DENIED});
    
    verify(callback).onResult("AudioAccessDenied", "Audio access permission was denied.");
  }

  @Test
  public void callback_doesNotRespond() {
    ResultCallback callback = mock (ResultCallback.class);
    CameraRequestPermissionsListener permissionsListener =
        new CameraRequestPermissionsListener(callback);

    permissionsListener.onRequestPermissionsResult(
      9796, null, new int[] {PackageManager.GRANTED, PackageManager.GRANTED});
    
    verify(callback, never()).onResult("CameraAccessDenied", "Camera access permission was denied.");
    verify(callback, never()).onResult("AudioAccessDenied", "Audio access permission was denied.");
  }
}
