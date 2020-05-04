// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.imagepicker;

import android.content.Context;
import android.net.Uri;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.shadows.ShadowContentResolver;

import java.io.BufferedInputStream;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;

import androidx.test.core.app.ApplicationProvider;

import static java.nio.charset.StandardCharsets.UTF_8;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.robolectric.Shadows.shadowOf;

@RunWith(RobolectricTestRunner.class)
public class FileUtilTest {

    private Context context;
    private FileUtils fileUtils;
    ShadowContentResolver shadowContentResolver;

    @Before
    public void before() {
        context = ApplicationProvider.getApplicationContext();
        shadowContentResolver = shadowOf(context.getContentResolver());
        fileUtils = new FileUtils();
    }

    @Test
    public void FileUtil_GetPathFromUri() {
        Uri uri = Uri.parse("content://dummy/dummy.png");
        shadowContentResolver.registerInputStream(uri, new ByteArrayInputStream("imageStream".getBytes(UTF_8)));
        String path = fileUtils.getPathFromUri(context, uri);
        File file = new File(path);
        int size = (int) file.length();
        byte[] bytes = new byte[size];
        try {
            BufferedInputStream buf = new BufferedInputStream(new FileInputStream(file));
            buf.read(bytes, 0, bytes.length);
            buf.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        assertTrue(bytes.length > 0);
        String imageStream = new String(bytes, UTF_8);
        assertTrue(imageStream.equals("imageStream"));
    }
}
