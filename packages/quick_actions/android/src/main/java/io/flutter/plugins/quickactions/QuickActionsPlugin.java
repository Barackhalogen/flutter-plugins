// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.quickactions;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.graphics.drawable.Icon;
import android.os.Build;
import android.os.Bundle;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/** QuickActionsPlugin */
@SuppressWarnings("unchecked")
public class QuickActionsPlugin implements MethodCallHandler {
  private final Activity activity;
  private static MethodChannel channel;

  private QuickActionsPlugin(Activity activity) {
    this.activity = activity;
  }

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    channel = new MethodChannel(registrar.messenger(), "plugins.flutter.io/quick_actions");
    channel.setMethodCallHandler(new QuickActionsPlugin(registrar.activity()));
  }

  @Override
  @SuppressLint("NewApi")
  public void onMethodCall(MethodCall call, Result result) {
    if (Build.VERSION.SDK_INT < Build.VERSION_CODES.N_MR1) {
      // We already know that this functionality does not work for anything
      // lower than API 25 so we chose not to return error. Instead we do nothing.
      result.success(null);
      return;
    }
    ShortcutManager shortcutManager =
        (ShortcutManager) activity.getSystemService(Context.SHORTCUT_SERVICE);
    switch (call.method) {
      case "setShortcutItems":
        List<Map<String, String>> serializedShortcuts = call.arguments();
        List<ShortcutInfo> shortcuts = deserializeShortcuts(serializedShortcuts);
        shortcutManager.setDynamicShortcuts(shortcuts);
        break;
      case "clearShortcutItems":
        shortcutManager.removeAllDynamicShortcuts();
        break;
      default:
        result.notImplemented();
        return;
    }
    result.success(null);
  }

  @SuppressLint("NewApi")
  private List<ShortcutInfo> deserializeShortcuts(List<Map<String, String>> shortcuts) {
    List<ShortcutInfo> shortcutInfos = new ArrayList<>();
    for (Map<String, String> shortcut : shortcuts) {
      String icon = shortcut.get("icon");
      String type = shortcut.get("type");
      String title = shortcut.get("localizedTitle");
      ShortcutInfo.Builder shortcutBuilder = new ShortcutInfo.Builder(activity, type);
      if (icon != null) {
        int resourceId =
            activity.getResources().getIdentifier(icon, "drawable", activity.getPackageName());
        if (resourceId > 0) {
          shortcutBuilder.setIcon(Icon.createWithResource(activity, resourceId));
        }
      }
      shortcutBuilder.setLongLabel(title);
      shortcutBuilder.setShortLabel(title);
      Intent intent = new Intent(activity, ShortcutHandlerActivity.class);
      intent.setAction("plugins.flutter.io/quick_action");
      intent.putExtra("type", type);
      shortcutBuilder.setIntent(intent);
      shortcutInfos.add(shortcutBuilder.build());
    }
    return shortcutInfos;
  }

  /**
   * Handle the shortcut and immediately closes the activity.
   *
   * <p>Needs to be invokable by Android system; hence it is public.
   */
  public static class ShortcutHandlerActivity extends Activity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
      super.onCreate(savedInstanceState);
      // Get the Intent that started this activity and extract the string
      Intent intent = getIntent();
      String type = intent.getStringExtra("type");
      channel.invokeMethod("launch", type);
      finish();
    }
  }
}
