package io.flutter.plugins.androidintent;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * Plugin implementation that uses the new {@code io.flutter.embedding} package.
 *
 * <p>Instantiate this in an add to app scenario to gracefully handle activity and context changes.
 */
public final class AndroidIntentPlugin implements FlutterPlugin, ActivityAware {
  private final IntentSender sender;
  private final MethodCallHandlerImpl impl;

  /**
   * Initialize this within the {@code #configureFlutterEngine} of a Flutter activity or fragment.
   *
   * <p>See {@code io.flutter.plugins.androidintentexample.MainActivity} for an example.
   */
  public AndroidIntentPlugin() {
    sender = new IntentSender(/*activity=*/ null, /*applicationContext=*/ null);
    impl = new MethodCallHandlerImpl(sender);
  }

  /**
   * Registers a plugin implementation that uses the stable {@code io.flutter.plugin.common}
   * package.
   *
   * <p>Calling this automatically initializes the plugin. However plugins initialized this way
   * won't react to changes in activity or context, unlike {@link AndroidIntentPlugin}.
   */
  public static void registerWith(Registrar registrar) {
    IntentSender sender = new IntentSender(registrar.activity(), registrar.context());
    MethodCallHandlerImpl impl = new MethodCallHandlerImpl(sender);
    impl.startListening(registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    sender.setApplicationContext(binding.getApplicationContext());
    sender.setActivity(null);
    impl.startListening(binding.getBinaryMessenger());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    sender.setApplicationContext(null);
    sender.setActivity(null);
    impl.stopListening();
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    sender.setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    sender.setActivity(null);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Context context = getActiveContext();
    String action = convertAction((String) call.argument("action"));

    // Build intent
    Intent intent = new Intent(action);
    if (call.argument("type") != null) {
      intent.setType((String) call.argument("type"));
    }
    if (mRegistrar.activity() == null) {
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    }
    if (call.argument("category") != null) {
      intent.addCategory((String) call.argument("category"));
    }
    if (call.argument("data") != null) {
      intent.setData(Uri.parse((String) call.argument("data")));
    }
    if (call.argument("arguments") != null) {
      intent.putExtras(convertArguments((Map) call.argument("arguments")));
    }
    if (call.argument("package") != null) {
      intent.setPackage((String) call.argument("package"));
      if (intent.resolveActivity(context.getPackageManager()) == null) {
        Log.i(TAG, "Cannot resolve explicit intent - ignoring package");
        intent.setPackage(null);
      }
    }

    Log.i(TAG, "Sending intent " + intent);
    context.startActivity(intent);

    result.success(null);
  }
  
  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }
}
