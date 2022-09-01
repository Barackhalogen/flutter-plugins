package com.example.wrapper_example;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;
import com.example.wrapper_example.example_library.MyClass;
import com.example.wrapper_example.example_library.MyOtherClass;
import io.flutter.plugin.common.BinaryMessenger;
import java.util.Objects;

public class MyClassHostApiImpl implements GeneratedExampleLibraryApis.MyClassHostApi {
  private final BinaryMessenger binaryMessenger;
  private final InstanceManager instanceManager;
  private final MyClassProxy myClassProxy;

  public static class MyClassProxy {
    public void myStaticMethod() {
      MyClass.myStaticMethod();
    }
  }

  public static class MyClassImpl extends MyClass {
    private final MyClassFlutterApiImpl api;

    public MyClassImpl(
        String primitiveField,
        MyOtherClass classField,
        BinaryMessenger binaryMessenger,
        InstanceManager instanceManager) {
      super(primitiveField, classField);
      api = new MyClassFlutterApiImpl(binaryMessenger, instanceManager);
    }

    @Override
    public void myCallbackMethod() {
      getApi().myCallbackMethod(this, reply -> {});
    }

    @VisibleForTesting
    public MyClassFlutterApiImpl getApi() {
      return api;
    }
  }

  public MyClassHostApiImpl(BinaryMessenger binaryMessenger, InstanceManager instanceManager) {
    this(binaryMessenger, instanceManager, new MyClassProxy());
  }

  public MyClassHostApiImpl(
      BinaryMessenger binaryMessenger,
      InstanceManager instanceManager,
      @VisibleForTesting MyClassProxy myClassProxy) {
    this.binaryMessenger = binaryMessenger;
    this.instanceManager = instanceManager;
    this.myClassProxy = myClassProxy;
  }

  @Override
  public void create(
      @NonNull Long identifier,
      @NonNull String primitiveField,
      @NonNull Long classFieldIdentifier) {
    instanceManager.addDartCreatedInstance(
        new MyClassImpl(
            primitiveField,
            instanceManager.getInstance(classFieldIdentifier),
            binaryMessenger,
            instanceManager),
        identifier);
  }

  @Override
  public void myStaticMethod() {
    myClassProxy.myStaticMethod();
  }

  @Override
  public void myMethod(
      @NonNull Long identifier,
      @NonNull String primitiveParam,
      @NonNull Long classParamIdentifier) {
    getMyClass(identifier)
        .myMethod(
            primitiveParam,
            Objects.requireNonNull(instanceManager.getInstance(classParamIdentifier)));
  }

  @Override
  public void attachClassField(@NonNull Long identifier, @NonNull Long classFieldIdentifier) {
    instanceManager.addDartCreatedInstance(getMyClass(identifier).classField, classFieldIdentifier);
  }

  private MyClass getMyClass(Long identifier) {
    return Objects.requireNonNull(instanceManager.getInstance(identifier));
  }
}
