// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v3.2.9), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package io.flutter.plugins.camerax;

import android.util.Log;
import androidx.annotation.NonNull;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class GeneratedCameraXLibrary {
  private static class JavaObjectHostApiCodec extends StandardMessageCodec {
    public static final JavaObjectHostApiCodec INSTANCE = new JavaObjectHostApiCodec();

    private JavaObjectHostApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface JavaObjectHostApi {
    void dispose(@NonNull Long identifier);

    /** The codec used by JavaObjectHostApi. */
    static MessageCodec<Object> getCodec() {
      return JavaObjectHostApiCodec.INSTANCE;
    }

    /**
     * Sets up an instance of `JavaObjectHostApi` to handle messages through the `binaryMessenger`.
     */
    static void setup(BinaryMessenger binaryMessenger, JavaObjectHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.JavaObjectHostApi.dispose", getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                Map<String, Object> wrapped = new HashMap<>();
                try {
                  ArrayList<Object> args = (ArrayList<Object>) message;
                  Number identifierArg = (Number) args.get(0);
                  if (identifierArg == null) {
                    throw new NullPointerException("identifierArg unexpectedly null.");
                  }
                  api.dispose((identifierArg == null) ? null : identifierArg.longValue());
                  wrapped.put("result", null);
                } catch (Error | RuntimeException exception) {
                  wrapped.put("error", wrapError(exception));
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }

  private static class JavaObjectFlutterApiCodec extends StandardMessageCodec {
    public static final JavaObjectFlutterApiCodec INSTANCE = new JavaObjectFlutterApiCodec();

    private JavaObjectFlutterApiCodec() {}
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class JavaObjectFlutterApi {
    private final BinaryMessenger binaryMessenger;

    public JavaObjectFlutterApi(BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    public interface Reply<T> {
      void reply(T reply);
    }

    static MessageCodec<Object> getCodec() {
      return JavaObjectFlutterApiCodec.INSTANCE;
    }

    public void dispose(@NonNull Long identifierArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.JavaObjectFlutterApi.dispose", getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(identifierArg)),
          channelReply -> {
            callback.reply(null);
          });
    }
  }

  private static class CameraInfoHostApiCodec extends StandardMessageCodec {
    public static final CameraInfoHostApiCodec INSTANCE = new CameraInfoHostApiCodec();

    private CameraInfoHostApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface CameraInfoHostApi {
    @NonNull
    Long getSensorRotationDegrees(@NonNull Long identifier);

    /** The codec used by CameraInfoHostApi. */
    static MessageCodec<Object> getCodec() {
      return CameraInfoHostApiCodec.INSTANCE;
    }

    /**
     * Sets up an instance of `CameraInfoHostApi` to handle messages through the `binaryMessenger`.
     */
    static void setup(BinaryMessenger binaryMessenger, CameraInfoHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.CameraInfoHostApi.getSensorRotationDegrees",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                Map<String, Object> wrapped = new HashMap<>();
                try {
                  ArrayList<Object> args = (ArrayList<Object>) message;
                  Number identifierArg = (Number) args.get(0);
                  if (identifierArg == null) {
                    throw new NullPointerException("identifierArg unexpectedly null.");
                  }
                  Long output =
                      api.getSensorRotationDegrees(
                          (identifierArg == null) ? null : identifierArg.longValue());
                  wrapped.put("result", output);
                } catch (Error | RuntimeException exception) {
                  wrapped.put("error", wrapError(exception));
                }
                reply.reply(wrapped);
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
    }
  }

  private static class CameraInfoFlutterApiCodec extends StandardMessageCodec {
    public static final CameraInfoFlutterApiCodec INSTANCE = new CameraInfoFlutterApiCodec();

    private CameraInfoFlutterApiCodec() {}
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class CameraInfoFlutterApi {
    private final BinaryMessenger binaryMessenger;

    public CameraInfoFlutterApi(BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    public interface Reply<T> {
      void reply(T reply);
    }

    static MessageCodec<Object> getCodec() {
      return CameraInfoFlutterApiCodec.INSTANCE;
    }

    public void create(@NonNull Long identifierArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.CameraInfoFlutterApi.create", getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(identifierArg)),
          channelReply -> {
            callback.reply(null);
          });
    }
  }

  private static Map<String, Object> wrapError(Throwable exception) {
    Map<String, Object> errorMap = new HashMap<>();
    errorMap.put("message", exception.toString());
    errorMap.put("code", exception.getClass().getSimpleName());
    errorMap.put(
        "details",
        "Cause: " + exception.getCause() + ", Stacktrace: " + Log.getStackTraceString(exception));
    return errorMap;
  }
}
