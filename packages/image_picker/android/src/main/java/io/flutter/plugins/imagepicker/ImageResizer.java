// Copyright 2019 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.imagepicker;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.util.Log;
import androidx.annotation.VisibleForTesting;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;

class ImageResizer {
  private final File externalFilesDirectory;
  private final ExifDataCopier exifDataCopier;

  ImageResizer(File externalFilesDirectory, ExifDataCopier exifDataCopier) {
    this.externalFilesDirectory = externalFilesDirectory;
    this.exifDataCopier = exifDataCopier;
  }

  /**
   * If necessary, resizes the image located in imagePath and then returns the path for the scaled
   * image.
   *
   * <p>If no resizing is needed, returns the path for the original image.
   */
  String resizeImageIfNeeded(
      String imagePath, Double maxWidth, Double maxHeight, Integer imageQuality) {
    boolean shouldScale =
        maxWidth != null
            || maxHeight != null
            || (imageQuality != null && imageQuality > -1 && imageQuality < 101);

    if (!shouldScale) {
      return imagePath;
    }

    try {
      Bitmap bmp = decodeFile(imagePath);
      if (bmp == null) {
        return null;
      }
      String[] pathParts = imagePath.split("/");
      String imageName = pathParts[pathParts.length - 1];
      File scaledImage = resizedImage(bmp, maxWidth, maxHeight, imageQuality, imageName);
      copyExif(imagePath, scaledImage.getPath());

      return scaledImage.getPath();
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  private File resizedImage(
      Bitmap bmp, Double maxWidth, Double maxHeight, Integer imageQuality, String outputImageName)
      throws IOException {
    double originalWidth = bmp.getWidth() * 1.0;
    double originalHeight = bmp.getHeight() * 1.0;

    if (imageQuality == null || imageQuality < 0 || imageQuality > 100) {
      imageQuality = 100;
    }

    boolean hasMaxWidth = maxWidth != null;
    boolean hasMaxHeight = maxHeight != null;

    Double width = hasMaxWidth ? Math.min(originalWidth, maxWidth) : originalWidth;
    Double height = hasMaxHeight ? Math.min(originalHeight, maxHeight) : originalHeight;

    boolean shouldDownscaleWidth = hasMaxWidth && maxWidth < originalWidth;
    boolean shouldDownscaleHeight = hasMaxHeight && maxHeight < originalHeight;
    boolean shouldDownscale = shouldDownscaleWidth || shouldDownscaleHeight;

    if (shouldDownscale) {
      double downscaledWidth = (height / originalHeight) * originalWidth;
      double downscaledHeight = (width / originalWidth) * originalHeight;

      if (width < height) {
        if (!hasMaxWidth) {
          width = downscaledWidth;
        } else {
          height = downscaledHeight;
        }
      } else if (height < width) {
        if (!hasMaxHeight) {
          height = downscaledHeight;
        } else {
          width = downscaledWidth;
        }
      } else {
        if (originalWidth < originalHeight) {
          width = downscaledWidth;
        } else if (originalHeight < originalWidth) {
          height = downscaledHeight;
        }
      }
    }

    Bitmap scaledBmp = createScaledBitmap(bmp, width.intValue(), height.intValue(), false);
    ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
    boolean saveAsPNG = bmp.hasAlpha();
    if (saveAsPNG) {
      Log.d(
          "ImageResizer",
          "image_picker: compressing is not supported for type PNG. Returning the image with original quality");
    }
    scaledBmp.compress(
        saveAsPNG ? Bitmap.CompressFormat.PNG : Bitmap.CompressFormat.JPEG,
        imageQuality,
        outputStream);

    File imageFile = createFile(externalFilesDirectory, "/scaled_" + outputImageName);
    FileOutputStream fileOutput = createOutputStream(imageFile);
    fileOutput.write(outputStream.toByteArray());
    fileOutput.close();
    return imageFile;
  }

  @VisibleForTesting
  File createFile(File externalFilesDirectory, String child) {
    return new File(externalFilesDirectory, child);
  }

  @VisibleForTesting
  FileOutputStream createOutputStream(File imageFile) throws IOException {
    return new FileOutputStream(imageFile);
  }

  @VisibleForTesting
  void copyExif(String filePathOri, String filePathDest) {
    exifDataCopier.copyExif(filePathOri, filePathDest);
  }

  @VisibleForTesting
  Bitmap decodeFile(String path) {
    return BitmapFactory.decodeFile(path);
  }

  @VisibleForTesting
  Bitmap createScaledBitmap(Bitmap bmp, int width, int height, boolean filter) {
    return Bitmap.createScaledBitmap(bmp, width, height, filter);
  }
}
