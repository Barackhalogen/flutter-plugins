// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// Autogenerated from Pigeon (v3.2.9), do not edit directly.
// See also: https://pub.dev/packages/pigeon

package io.flutter.plugins.camerax;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MessageCodec;
import io.flutter.plugin.common.StandardMessageCodec;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Generated class from Pigeon. */
@SuppressWarnings({"unused", "unchecked", "CodeBlock2Expr", "RedundantSuppression"})
public class GeneratedCameraXLibrary {

  public interface Result<T> {
    void success(T result);

    void error(Throwable error);
  }

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

  private static class CameraSelectorHostApiCodec extends StandardMessageCodec {
    public static final CameraSelectorHostApiCodec INSTANCE = new CameraSelectorHostApiCodec();

    private CameraSelectorHostApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface CameraSelectorHostApi {
    void create(@NonNull Long identifier, @Nullable Long lensFacing);

    @NonNull
    List<Long> filter(@NonNull Long identifier, @NonNull List<Long> cameraInfoIds);

    /** The codec used by CameraSelectorHostApi. */
    static MessageCodec<Object> getCodec() {
      return CameraSelectorHostApiCodec.INSTANCE;
    }

    /**
     * Sets up an instance of `CameraSelectorHostApi` to handle messages through the
     * `binaryMessenger`.
     */
    static void setup(BinaryMessenger binaryMessenger, CameraSelectorHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.CameraSelectorHostApi.create", getCodec());
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
                  Number lensFacingArg = (Number) args.get(1);
                  api.create(
                      (identifierArg == null) ? null : identifierArg.longValue(),
                      (lensFacingArg == null) ? null : lensFacingArg.longValue());
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
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger, "dev.flutter.pigeon.CameraSelectorHostApi.filter", getCodec());
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
                  List<Long> cameraInfoIdsArg = (List<Long>) args.get(1);
                  if (cameraInfoIdsArg == null) {
                    throw new NullPointerException("cameraInfoIdsArg unexpectedly null.");
                  }
                  List<Long> output =
                      api.filter(
                          (identifierArg == null) ? null : identifierArg.longValue(),
                          cameraInfoIdsArg);
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

  private static class CameraSelectorFlutterApiCodec extends StandardMessageCodec {
    public static final CameraSelectorFlutterApiCodec INSTANCE =
        new CameraSelectorFlutterApiCodec();

    private CameraSelectorFlutterApiCodec() {}
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class CameraSelectorFlutterApi {
    private final BinaryMessenger binaryMessenger;

    public CameraSelectorFlutterApi(BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    public interface Reply<T> {
      void reply(T reply);
    }

    static MessageCodec<Object> getCodec() {
      return CameraSelectorFlutterApiCodec.INSTANCE;
    }

    public void create(
        @NonNull Long identifierArg, @Nullable Long lensFacingArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.CameraSelectorFlutterApi.create", getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(identifierArg, lensFacingArg)),
          channelReply -> {
            callback.reply(null);
          });
    }
  }

  private static class ProcessCameraProviderHostApiCodec extends StandardMessageCodec {
    public static final ProcessCameraProviderHostApiCodec INSTANCE =
        new ProcessCameraProviderHostApiCodec();

    private ProcessCameraProviderHostApiCodec() {}
  }

  /** Generated interface from Pigeon that represents a handler of messages from Flutter. */
  public interface ProcessCameraProviderHostApi {
    void getInstance(Result<Long> result);

    @NonNull
    List<Long> getAvailableCameraInfos(@NonNull Long identifier);

    @NonNull
    Long bindToLifecycle(
        @NonNull Long identifier,
        @NonNull Long cameraSelectorIdentifier,
        @NonNull List<Long> useCaseIds);

    void unbind(@NonNull Long identifier, @NonNull List<Long> useCaseIds);

    void unbindAll(@NonNull Long identifier);

    /** The codec used by ProcessCameraProviderHostApi. */
    static MessageCodec<Object> getCodec() {
      return ProcessCameraProviderHostApiCodec.INSTANCE;
    }

    /**
     * Sets up an instance of `ProcessCameraProviderHostApi` to handle messages through the
     * `binaryMessenger`.
     */
    static void setup(BinaryMessenger binaryMessenger, ProcessCameraProviderHostApi api) {
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.ProcessCameraProviderHostApi.getInstance",
                getCodec());
        if (api != null) {
          channel.setMessageHandler(
              (message, reply) -> {
                Map<String, Object> wrapped = new HashMap<>();
                try {
                  Result<Long> resultCallback =
                      new Result<Long>() {
                        public void success(Long result) {
                          wrapped.put("result", result);
                          reply.reply(wrapped);
                        }

                        public void error(Throwable error) {
                          wrapped.put("error", wrapError(error));
                          reply.reply(wrapped);
                        }
                      };

                  api.getInstance(resultCallback);
                } catch (Error | RuntimeException exception) {
                  wrapped.put("error", wrapError(exception));
                  reply.reply(wrapped);
                }
              });
        } else {
          channel.setMessageHandler(null);
        }
      }
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.ProcessCameraProviderHostApi.getAvailableCameraInfos",
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
                  List<Long> output =
                      api.getAvailableCameraInfos(
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
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.ProcessCameraProviderHostApi.bindToLifecycle",
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
                  Number cameraSelectorIdentifierArg = (Number) args.get(1);
                  if (cameraSelectorIdentifierArg == null) {
                    throw new NullPointerException(
                        "cameraSelectorIdentifierArg unexpectedly null.");
                  }
                  List<Long> useCaseIdsArg = (List<Long>) args.get(2);
                  if (useCaseIdsArg == null) {
                    throw new NullPointerException("useCaseIdsArg unexpectedly null.");
                  }
                  Long output =
                      api.bindToLifecycle(
                          (identifierArg == null) ? null : identifierArg.longValue(),
                          (cameraSelectorIdentifierArg == null)
                              ? null
                              : cameraSelectorIdentifierArg.longValue(),
                          useCaseIdsArg);
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
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.ProcessCameraProviderHostApi.unbind",
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
                  List<Long> useCaseIdsArg = (List<Long>) args.get(1);
                  if (useCaseIdsArg == null) {
                    throw new NullPointerException("useCaseIdsArg unexpectedly null.");
                  }
                  api.unbind(
                      (identifierArg == null) ? null : identifierArg.longValue(), useCaseIdsArg);
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
      {
        BasicMessageChannel<Object> channel =
            new BasicMessageChannel<>(
                binaryMessenger,
                "dev.flutter.pigeon.ProcessCameraProviderHostApi.unbindAll",
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
                  api.unbindAll((identifierArg == null) ? null : identifierArg.longValue());
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

  private static class ProcessCameraProviderFlutterApiCodec extends StandardMessageCodec {
    public static final ProcessCameraProviderFlutterApiCodec INSTANCE =
        new ProcessCameraProviderFlutterApiCodec();

    private ProcessCameraProviderFlutterApiCodec() {}
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class ProcessCameraProviderFlutterApi {
    private final BinaryMessenger binaryMessenger;

    public ProcessCameraProviderFlutterApi(BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    public interface Reply<T> {
      void reply(T reply);
    }

    static MessageCodec<Object> getCodec() {
      return ProcessCameraProviderFlutterApiCodec.INSTANCE;
    }

    public void create(@NonNull Long identifierArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger,
              "dev.flutter.pigeon.ProcessCameraProviderFlutterApi.create",
              getCodec());
      channel.send(
          new ArrayList<Object>(Arrays.asList(identifierArg)),
          channelReply -> {
            callback.reply(null);
          });
    }
  }

  private static class CameraFlutterApiCodec extends StandardMessageCodec {
    public static final CameraFlutterApiCodec INSTANCE = new CameraFlutterApiCodec();

    private CameraFlutterApiCodec() {}
  }

  /** Generated class from Pigeon that represents Flutter messages that can be called from Java. */
  public static class CameraFlutterApi {
    private final BinaryMessenger binaryMessenger;

    public CameraFlutterApi(BinaryMessenger argBinaryMessenger) {
      this.binaryMessenger = argBinaryMessenger;
    }

    public interface Reply<T> {
      void reply(T reply);
    }

    static MessageCodec<Object> getCodec() {
      return CameraFlutterApiCodec.INSTANCE;
    }

    public void create(@NonNull Long identifierArg, Reply<Void> callback) {
      BasicMessageChannel<Object> channel =
          new BasicMessageChannel<>(
              binaryMessenger, "dev.flutter.pigeon.CameraFlutterApi.create", getCodec());
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
