// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.camera.features.zoomlevel;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyFloat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import android.graphics.Rect;
import android.hardware.camera2.CaptureRequest;
import io.flutter.plugins.camera.CameraProperties;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

public class ZoomLevelFeatureTest {
  private MockedStatic<ZoomUtils> mockedStaticCameraZoom;
  private CameraProperties mockCameraProperties;
  private ZoomUtils mockCameraZoom;
  private Rect mockZoomArea;
  private Rect mockSensorArray;

  @Before
  public void before() {
    mockedStaticCameraZoom = mockStatic(ZoomUtils.class);
    mockCameraProperties = mock(CameraProperties.class);
    mockCameraZoom = mock(ZoomUtils.class);
    mockZoomArea = mock(Rect.class);
    mockSensorArray = mock(Rect.class);

    mockedStaticCameraZoom.when(() -> ZoomUtils.computeZoom(anyFloat(), any(), anyFloat(), anyFloat())).thenReturn(mockZoomArea);
  }

  @After
  public void after() {
    mockedStaticCameraZoom.close();
  }

  @Test
  public void ctor_when_parameters_are_valid() {
    when(mockCameraProperties.getSensorInfoActiveArraySize()).thenReturn(mockSensorArray);
    when(mockCameraProperties.getScalerAvailableMaxDigitalZoom()).thenReturn(42f);

    final ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    verify(mockCameraProperties, times(1)).getSensorInfoActiveArraySize();
    verify(mockCameraProperties, times(1)).getScalerAvailableMaxDigitalZoom();
    assertNotNull(zoomLevelFeature);
    assertEquals(42f, zoomLevelFeature.getMaximumZoomLevel(), 0);
  }

  @Test
  public void ctor_when_sensor_size_is_null() {
    when(mockCameraProperties.getSensorInfoActiveArraySize()).thenReturn(null);
    when(mockCameraProperties.getScalerAvailableMaxDigitalZoom()).thenReturn(42f);

    final ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    verify(mockCameraProperties, times(1)).getSensorInfoActiveArraySize();
    verify(mockCameraProperties, never()).getScalerAvailableMaxDigitalZoom();
    assertNotNull(zoomLevelFeature);
    assertFalse(zoomLevelFeature.checkIsSupported());
    assertEquals(zoomLevelFeature.getMaximumZoomLevel(), 1.0f, 0);
  }

  @Test
  public void ctor_when_max_zoom_is_null() {
    when(mockCameraProperties.getSensorInfoActiveArraySize()).thenReturn(mockSensorArray);
    when(mockCameraProperties.getScalerAvailableMaxDigitalZoom()).thenReturn(null);

    final ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    verify(mockCameraProperties, times(1)).getSensorInfoActiveArraySize();
    verify(mockCameraProperties, times(1)).getScalerAvailableMaxDigitalZoom();
    assertNotNull(zoomLevelFeature);
    assertFalse(zoomLevelFeature.checkIsSupported());
    assertEquals(zoomLevelFeature.getMaximumZoomLevel(), 1.0f, 0);
  }

  @Test
  public void ctor_when_max_zoom_is_smaller_then_default_zoom_factor() {
    when(mockCameraProperties.getSensorInfoActiveArraySize()).thenReturn(mockSensorArray);
    when(mockCameraProperties.getScalerAvailableMaxDigitalZoom()).thenReturn(0.5f);

    final ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    verify(mockCameraProperties, times(1)).getSensorInfoActiveArraySize();
    verify(mockCameraProperties, times(1)).getScalerAvailableMaxDigitalZoom();
    assertNotNull(zoomLevelFeature);
    assertFalse(zoomLevelFeature.checkIsSupported());
    assertEquals(zoomLevelFeature.getMaximumZoomLevel(), 1.0f, 0);
  }

  @Test
  public void getDebugName_should_return_the_name_of_the_feature() {
    ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    assertEquals("ZoomLevelFeature", zoomLevelFeature.getDebugName());
  }

  @Test
  public void getValue_should_return_null_if_not_set() {
    ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    assertEquals(1.0, (float) zoomLevelFeature.getValue(), 0);
  }

  @Test
  public void getValue_should_echo_setValue() {
    ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    zoomLevelFeature.setValue(2.3f);

    assertEquals(2.3f, (float) zoomLevelFeature.getValue(), 0);
  }

  @Test
  public void checkIsSupport_returns_false_by_default() {
    ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    assertFalse(zoomLevelFeature.checkIsSupported());
  }

  @Test
  public void updateBuilder_should_set_scalar_crop_region_when_checkIsSupport_is_true() {
    when(mockCameraProperties.getSensorInfoActiveArraySize()).thenReturn(mockSensorArray);
    when(mockCameraProperties.getScalerAvailableMaxDigitalZoom()).thenReturn(42f);

    ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);
    CaptureRequest.Builder mockBuilder = mock(CaptureRequest.Builder.class);

    zoomLevelFeature.updateBuilder(mockBuilder);

    verify(mockBuilder, times(1)).set(CaptureRequest.SCALER_CROP_REGION, mockZoomArea);
  }

  @Test
  public void getMinimumZoomLevel() {
    ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    assertEquals(1.0f, zoomLevelFeature.getMinimumZoomLevel(), 0);
  }

  @Test
  public void getMaximumZoomLevel() {
    when(mockCameraProperties.getSensorInfoActiveArraySize()).thenReturn(mockSensorArray);
    when(mockCameraProperties.getScalerAvailableMaxDigitalZoom()).thenReturn(42f);

    ZoomLevelFeature zoomLevelFeature = new ZoomLevelFeature(mockCameraProperties);

    assertEquals(42f, zoomLevelFeature.getMaximumZoomLevel(), 0);
  }
}
