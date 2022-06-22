// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package io.flutter.plugins.quickactionsexample;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import android.content.Context;
import android.content.pm.ShortcutInfo;
import android.content.pm.ShortcutManager;
import android.util.Log;
import androidx.lifecycle.Lifecycle;
import androidx.test.core.app.ActivityScenario;
import androidx.test.core.app.ApplicationProvider;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.platform.app.InstrumentationRegistry;
import androidx.test.uiautomator.By;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiObjectNotFoundException;
import androidx.test.uiautomator.UiScrollable;
import androidx.test.uiautomator.UiSelector;
import androidx.test.uiautomator.Until;
import io.flutter.plugins.quickactions.QuickActionsPlugin;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicReference;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;

@RunWith(AndroidJUnit4.class)
public class QuickActionsTest {
  private Context context;
  private UiDevice device;
  private ActivityScenario<QuickActionsTestActivity> scenario;

  @Before
  public void setUp() {
    context = ApplicationProvider.getApplicationContext();
    device = UiDevice.getInstance(InstrumentationRegistry.getInstrumentation());
    scenario = ensureAppRunToView();
    ensureAllAppShortcutsAreCreated();
  }

  @After
  public void tearDown() {
    scenario.close();
    Log.i(QuickActionsTest.class.getSimpleName(), "Run to completion");
  }

  @Test
  public void quickActionPluginIsAdded() {
    final ActivityScenario<QuickActionsTestActivity> scenario =
        ActivityScenario.launch(QuickActionsTestActivity.class);
    scenario.onActivity(
        activity -> {
          assertTrue(activity.engine.getPlugins().has(QuickActionsPlugin.class));
        });
  }

  @Test
  public void appShortcutsAreCreated() {
    List<ShortcutInfo> expectedShortcuts = createMockShortcuts();

    ShortcutManager shortcutManager =
        (ShortcutManager) context.getSystemService(Context.SHORTCUT_SERVICE);
    List<ShortcutInfo> dynamicShortcuts = shortcutManager.getDynamicShortcuts();

    // Assert the app shortcuts defined in ../lib/main.dart.
    assertFalse(dynamicShortcuts.isEmpty());
    assertEquals(expectedShortcuts.size(), dynamicShortcuts.size());
    for (ShortcutInfo expectedShortcut : expectedShortcuts) {
      ShortcutInfo dynamicShortcut =
          dynamicShortcuts
              .stream()
              .filter(s -> s.getId().equals(expectedShortcut.getId()))
              .findFirst()
              .get();

      assertEquals(expectedShortcut.getShortLabel(), dynamicShortcut.getShortLabel());
      assertEquals(expectedShortcut.getLongLabel(), dynamicShortcut.getLongLabel());
    }
  }

  @Test
  public void appShortcutExistsAfterLongPressingAppIcon() throws UiObjectNotFoundException {
    List<ShortcutInfo> shortcuts = createMockShortcuts();
    String appName = context.getApplicationInfo().loadLabel(context.getPackageManager()).toString();

    findAppIcon(device, appName).longClick();

    for (ShortcutInfo shortcut : shortcuts) {
      Assert.assertTrue(
          "The specified shortcut label '" + shortcut.getShortLabel() + "' does not exist.",
          device.hasObject(By.text(shortcut.getShortLabel().toString())));
    }
  }

  @Test
  public void appShortcutLaunchActivityAfterPressing() throws UiObjectNotFoundException {
    Log.i(
        QuickActionsTest.class.getSimpleName(),
        "Start running appShortcutLaunchActivityAfterPressing test");

    // Arrange
    List<ShortcutInfo> shortcuts = createMockShortcuts();
    String appName = context.getApplicationInfo().loadLabel(context.getPackageManager()).toString();
    ShortcutInfo firstShortcut = shortcuts.get(0);
    AtomicReference<QuickActionsTestActivity> initialActivity = new AtomicReference<>();
    scenario.onActivity(initialActivity::set);

    // Act
    findAppIcon(device, appName).longClick();
    UiObject appShortcut =
        device.findObject(new UiSelector().text(firstShortcut.getShortLabel().toString()));
    appShortcut.clickAndWaitForNewWindow();
    device.wait(Until.hasObject(By.descContains("On home screen")), 1000);
    AtomicReference<QuickActionsTestActivity> currentActivity = new AtomicReference<>();
    scenario.onActivity(currentActivity::set);

    // Assert
    Assert.assertTrue(
        "AppShortcut:" + firstShortcut.getId() + " does not launch the correct activity",
        // We can only find the shortcut type in content description while inspecting it in Ui
        // Automator Viewer.
        device.hasObject(By.desc(firstShortcut.getId())));
    // This is Android SingleTop behavior in which Android does not destroy the initial activity and
    // launch a new activity.
    Assert.assertEquals(initialActivity.get(), currentActivity.get());
  }

  private void ensureAllAppShortcutsAreCreated() {
    device.wait(Until.hasObject(By.text("actions ready")), 1000);
  }

  private List<ShortcutInfo> createMockShortcuts() {
    List<ShortcutInfo> expectedShortcuts = new ArrayList<>();

    String actionOneLocalizedTitle = "Action one";
    expectedShortcuts.add(
        new ShortcutInfo.Builder(context, "action_one")
            .setShortLabel(actionOneLocalizedTitle)
            .setLongLabel(actionOneLocalizedTitle)
            .build());

    String actionTwoLocalizedTitle = "Action two";
    expectedShortcuts.add(
        new ShortcutInfo.Builder(context, "action_two")
            .setShortLabel(actionTwoLocalizedTitle)
            .setLongLabel(actionTwoLocalizedTitle)
            .build());

    return expectedShortcuts;
  }

  private ActivityScenario<QuickActionsTestActivity> ensureAppRunToView() {
    final ActivityScenario<QuickActionsTestActivity> scenario =
        ActivityScenario.launch(QuickActionsTestActivity.class);
    scenario.moveToState(Lifecycle.State.STARTED);
    return scenario;
  }

  private UiObject findAppIcon(UiDevice device, String appName) throws UiObjectNotFoundException {
    Log.i(QuickActionsTest.class.getSimpleName(), "Find app icon, pressing home...");
    boolean pressHomeResult = device.pressHome();
    Log.i(QuickActionsTest.class.getSimpleName(), "Press home result: " + pressHomeResult);

    // Swipe up to open App Drawer
    UiScrollable homeView = new UiScrollable(new UiSelector().scrollable(true));
    homeView.scrollForward();

    if (!device.hasObject(By.text(appName))) {
      Log.i(
          QuickActionsTest.class.getSimpleName(),
          "Attempting to scroll App Drawer for App Icon...");
      UiScrollable appDrawer = new UiScrollable(new UiSelector().scrollable(true));
      // The scrollTextIntoView scrolls to the beginning before performing searching scroll; this
      // causes an issue in a scenario where the view is already in the beginning. In this case, it
      // scrolls back to home view. Therefore, we perform a dummy forward scroll to ensure it is not
      // in the beginning.
      appDrawer.scrollForward();
      appDrawer.scrollTextIntoView(appName);
    }

    return device.findObject(new UiSelector().text(appName));
  }
}
