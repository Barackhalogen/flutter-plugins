package io.flutter.plugins.localauth;

import androidx.annotation.VisibleForTesting;
import androidx.fragment.app.FragmentActivity;
import androidx.lifecycle.Lifecycle;
import io.flutter.plugin.common.MethodCall;

/** Factory class that assists in creating a {@link AuthenticationHelper} instance. */
class AuthenticationHelperFactory {
  @VisibleForTesting
  public static AuthenticationHelper create(
      Lifecycle lifecycle,
      FragmentActivity activity,
      MethodCall call,
      AuthenticationHelper.AuthCompletionHandler completionHandler,
      int[] allowedAuthenticators) {
    return new AuthenticationHelper(
        lifecycle, activity, call, completionHandler, allowedAuthenticators);
  }
}
