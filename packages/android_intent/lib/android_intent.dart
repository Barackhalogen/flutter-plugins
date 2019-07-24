// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:platform/platform.dart';

const String kChannelName = 'plugins.flutter.io/android_intent';

/// Flutter plugin for launching arbitrary Android Intents.
class AndroidIntent {
  /// Builds an Android intent with the following parameters
  /// [action] refers to the action parameter of the intent.
  /// [category] refers to the category of the intent, can be null.
  /// [data] refers to the string format of the URI that will be passed to
  /// intent.
  /// [arguments] is the map that will be converted into an extras bundle and
  /// passed to the intent.
  /// [package] refers to the package parameter of the intent, can be null.
  /// [componentName] refers to the component name of the intent, can be null.
  /// If not null, then [package] but also be provided.
  const AndroidIntent({
    @required this.action,
    this.category,
    this.data,
    this.arguments,
    this.package,
    this.componentName,
    Platform platform,
  })  : assert(action != null),
        _channel = const MethodChannel(kChannelName),
        _platform = platform ?? const LocalPlatform();

  final String action;
  final String category;
  final String data;
  final Map<String, dynamic> arguments;
  final String package;
  final String componentName;
  final MethodChannel _channel;
  final Platform _platform;

  /// Launch the intent.
  ///
  /// This works only on Android platforms. Please guard the call so that your
  /// iOS app does not crash. Checked mode will throw an assert exception.
  Future<void> launch() async {
    assert(_platform.isAndroid);
    final Map<String, dynamic> args = <String, dynamic>{'action': action};
    if (category != null) {
      args['category'] = category;
    }
    if (data != null) {
      args['data'] = data;
    }
    if (arguments != null) {
      args['arguments'] = arguments;
    }
    if (package != null) {
      args['package'] = package;
      if (componentName != null) {
        args['componentName'] = componentName;
      }
    }
    await _channel.invokeMethod<void>('launch', args);
  }

  static const String action_view = 'action_view';
  static const String action_add_account = 'action_add_account';
  static const String action_apn_settings = 'action_apn_settings';
  static const String action_accessibility_settings = 'action_accessibility_settings';
  static const String action_airplane_mode_settings = 'action_airplane_mode_settings';
  static const String action_application_development_settings = 'action_application_development_settings';
  static const String action_application_settings = 'action_application_settings';
  static const String action_app_notification_bubble_settings = 'action_app_notification_bubble_settings';
  static const String action_app_notification_settings = 'action_app_notification_settings';
  static const String action_app_search_settings = 'action_app_search_settings';
  static const String action_app_usage_settings = 'action_app_usage_settings';
  static const String action_battery_saver_settings = 'action_battery_saver_settings';
  static const String action_bluetooth_settings = 'action_bluetooth_settings';
  static const String action_captioning_settings = 'action_captioning_settings';
  static const String action_cast_settings = 'action_cast_settings';
  static const String action_channel_notification_settings = 'action_channel_notification_settings';
  static const String action_data_roaming_settings = 'action_data_roaming_settings';
  static const String action_data_usage_settings = 'action_data_usage_settings';
  static const String action_date_settings = 'action_date_settings';
  static const String action_device_info_settings = 'action_device_info_settings';
  static const String action_display_settings = 'action_display_settings';
  static const String action_dream_settings = 'action_dream_settings';
  static const String action_fingerprint_enroll = 'action_fingerprint_enroll';
  static const String action_hard_keyboard_settings = 'action_hard_keyboard_settings';
  static const String action_home_settings = 'action_home_settings';
  static const String action_ignore_background_data_restrictions_settings = 'action_ignore_background_data_restrictions_settings';
  static const String action_ignore_battery_optimization_settings = 'action_ignore_battery_optimization_settings';
  static const String action_input_method_settings = 'action_input_method_settings';
  static const String action_input_method_subtype_settings = 'action_input_method_subtype_settings';
  static const String action_internal_storage_settings = 'action_internal_storage_settings';
  static const String action_locale_settings = 'action_locale_settings';
  static const String action_location_source_settings = 'action_location_source_settings';
  static const String action_manage_all_applications_settings = 'action_manage_all_applications_settings';
  static const String action_manage_applications_settings = 'action_manage_applications_settings';
  static const String action_manage_default_apps_settings = 'action_manage_default_apps_settings';
  static const String action_manage_unknown_app_sources = 'action_manage_unknown_app_sources';
  static const String action_manage_write_settings = 'action_manage_write_settings';
  static const String action_memory_card_settings = 'action_memory_card_settings';
  static const String action_network_operator_settings = 'action_network_operator_settings';
  static const String action_nfcsharing_settings = 'action_nfcsharing_settings';
  static const String action_nfc_payment_settings = 'action_nfc_payment_settings';
  static const String action_nfc_settings = 'action_nfc_settings';
  static const String action_night_display_settings = 'action_night_display_settings';
  static const String action_notification_assistant_settings = 'action_notification_assistant_settings';
  static const String action_notification_listener_settings = 'action_notification_listener_settings';
  static const String action_notification_policy_access_settings = 'action_notification_policy_access_settings';
  static const String action_print_settings = 'action_print_settings';
  static const String action_privacy_settings = 'action_privacy_settings';
  static const String action_process_wifi_easy_connect_uri = 'action_process_wifi_easy_connect_uri';
  static const String action_quick_launch_settings = 'action_quick_launch_settings';
  static const String action_request_ignore_battery_optimizations = 'action_request_ignore_battery_optimizations';
  static const String action_request_set_autofill_service = 'action_request_set_autofill_service';
  static const String action_search_settings = 'action_search_settings';
  static const String action_security_settings = 'action_security_settings';
  static const String action_settings = 'action_settings';
  static const String action_show_regulatory_info = 'action_show_regulatory_info';
  static const String action_sound_settings = 'action_sound_settings';
  static const String action_storage_volume_access_settings = 'action_storage_volume_access_settings';
  static const String action_application_details_settings = 'action_application_details_settings';
  static const String action_sync_settings = 'action_sync_settings';
  static const String action_usage_access_settings = 'action_usage_access_settings';
  static const String action_user_dictionary_settings = 'action_user_dictionary_settings';
  static const String action_voice_control_airplane_mode = 'action_voice_control_airplane_mode';
  static const String action_voice_control_battery_saver_mode = 'action_voice_control_battery_saver_mode';
  static const String action_voice_control_do_not_disturb_mode = 'action_voice_control_do_not_disturb_mode';
  static const String action_voice_input_settings = 'action_voice_input_settings';
  static const String action_vpn_settings = 'action_vpn_settings';
  static const String action_vr_listener_settings = 'action_vr_listener_settings';
  static const String action_webview_settings = 'action_webview_settings';
  static const String action_wifi_ip_settings = 'action_wifi_ip_settings';
  static const String action_wifi_settings = 'action_wifi_settings';
  static const String action_wireless_settings = 'action_wireless_settings';
  static const String action_zen_mode_priority_settings = 'action_zen_mode_priority_settings';

}
