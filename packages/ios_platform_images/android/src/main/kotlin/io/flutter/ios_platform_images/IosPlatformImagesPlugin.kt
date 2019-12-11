package io.flutter.ios_platform_images

import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

class IosPlatformImagesPlugin: MethodCallHandler {
  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "plugins.flutter.io/ios_platform_images")
      channel.setMethodCallHandler(IosPlatformImagesPlugin())
    }
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    result.error("AndroidNotSupported", "This plugin is for iOS only.", null)
  }
}
