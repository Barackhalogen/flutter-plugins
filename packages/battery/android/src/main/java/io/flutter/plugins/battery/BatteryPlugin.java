package io.flutter.plugins.battery;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/** BatteryPlugin */
public class BatteryPlugin implements MethodCallHandler, StreamHandler {

  /** Plugin registration. */
  public static void registerWith(PluginRegistry.Registrar registrar) {
    final MethodChannel methodChannel =
        new MethodChannel(registrar.messenger(), "plugins.flutter.io/battery");
    final EventChannel eventChannel =
        new EventChannel(registrar.messenger(), "plugins.flutter.io/charging");
    final BatteryPlugin instance = new BatteryPlugin(registrar.activity());
    eventChannel.setStreamHandler(instance);
    methodChannel.setMethodCallHandler(instance);
  }

  BatteryPlugin(Activity activity) {
    this.activity = activity;
  }

  private final Activity activity;
  private BroadcastReceiver chargingStateChangeReceiver;

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getBatteryLevel")) {
      int batteryLevel = getBatteryLevel();

      if (batteryLevel != -1) {
        result.success(batteryLevel);
      } else {
        result.error("UNAVAILABLE", "Battery level not available.", null);
      }
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onListen(Object arguments, EventSink events) {
    chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
    activity.registerReceiver(
        chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
  }

  @Override
  public void onCancel(Object arguments) {
    activity.unregisterReceiver(chargingStateChangeReceiver);
    chargingStateChangeReceiver = null;
  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager =
          (BatteryManager) activity.getSystemService(activity.BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent =
          new ContextWrapper(activity.getApplicationContext())
              .registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel =
          (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100)
              / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  private BroadcastReceiver createChargingStateChangeReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

        switch (status) {
          case BatteryManager.BATTERY_STATUS_CHARGING:
            events.success("charging");
            break;
          case BatteryManager.BATTERY_STATUS_FULL:
            events.success("full");
            break;
          case BatteryManager.BATTERY_STATUS_DISCHARGING:
            events.success("discharging");
            break;
          default:
            events.error("UNAVAILABLE", "Charging status unavailable", null);
            break;
        }
      }
    };
  }
}
