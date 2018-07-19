package io.flutter.plugins.firebasemlvision;

import android.graphics.Point;
import android.graphics.Rect;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;

import com.google.android.gms.tasks.OnFailureListener;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.ml.vision.FirebaseVision;
import com.google.firebase.ml.vision.common.FirebaseVisionImage;
import com.google.firebase.ml.vision.text.FirebaseVisionText;
import com.google.firebase.ml.vision.text.FirebaseVisionTextDetector;

import io.flutter.plugins.firebasemlvision.util.DetectedItemUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

public class TextDetector extends Detector {
  public static final TextDetector instance = new TextDetector();
  private static FirebaseVisionTextDetector textDetector;

  private final AtomicBoolean shouldThrottle = new AtomicBoolean(false);

  private TextDetector() {
  }

  @Override
  void processImage(FirebaseVisionImage image, final OperationFinishedCallback finishedCallback) {
    if (textDetector == null) textDetector = FirebaseVision.getInstance().getVisionTextDetector();
    textDetector
      .detectInImage(image)
      .addOnSuccessListener(
        new OnSuccessListener<FirebaseVisionText>() {
          @Override
          public void onSuccess(FirebaseVisionText firebaseVisionText) {
            List<Map<String, Object>> blocks = new ArrayList<>();
            for (FirebaseVisionText.Block block : firebaseVisionText.getBlocks()) {
              Map<String, Object> blockData = new HashMap<>();
              addTextData(
                blockData, block.getBoundingBox(), block.getCornerPoints(), block.getText());

              List<Map<String, Object>> lines = new ArrayList<>();
              for (FirebaseVisionText.Line line : block.getLines()) {
                Map<String, Object> lineData = new HashMap<>();
                addTextData(
                  lineData, line.getBoundingBox(), line.getCornerPoints(), line.getText());

                List<Map<String, Object>> elements = new ArrayList<>();
                for (FirebaseVisionText.Element element : line.getElements()) {
                  Map<String, Object> elementData = new HashMap<>();
                  addTextData(
                    elementData,
                    element.getBoundingBox(),
                    element.getCornerPoints(),
                    element.getText());
                  elements.add(elementData);
                }
                lineData.put("elements", elements);
                lines.add(lineData);
              }
              blockData.put("lines", lines);
              blocks.add(blockData);
            }
            finishedCallback.success(TextDetector.this, blocks);
          }
        })
      .addOnFailureListener(
        new OnFailureListener() {
          @Override
          public void onFailure(@NonNull Exception exception) {
            finishedCallback.error(new DetectorException("textDetectorError", exception.getLocalizedMessage(), null));
          }
        });
  }

  @Override
  public void close(@Nullable OperationFinishedCallback callback) {
    if (textDetector != null) {
      try {
        textDetector.close();
        if (callback != null) {
          callback.success(TextDetector.this, null);
        }
      } catch (IOException exception) {
        if (callback != null) {
          callback.error(new DetectorException("textDetectorError", exception.getLocalizedMessage(), null));
        }
      }

      textDetector = null;
    }
  }

  private void addTextData(
    Map<String, Object> addTo, Rect boundingBox, Point[] cornerPoints, String text) {
    addTo.put("text", text);

    if (boundingBox != null) {
      addTo.putAll(DetectedItemUtils.rectToFlutterMap(boundingBox));
    }

    List<int[]> points = new ArrayList<>();
    if (cornerPoints != null) {
      for (Point point : cornerPoints) {
        points.add(new int[]{point.x, point.y});
      }
    }
    addTo.put("points", points);
  }
}
