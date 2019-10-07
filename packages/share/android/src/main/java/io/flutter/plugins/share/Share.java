package io.flutter.plugins.share;

import android.app.Activity;
import android.content.Intent;
import androidx.annotation.Nullable;

/** Handles share intent. */
public class Share {

  private Activity activity;

  /**
   * Constructs a Share object. The {@code activity} is used to start the share intent. It might be
   * null when constructing the {@link Share} object and set to non-null when an activity is
   * available using {@link #setActivity(Activity)}.
   */
  public Share(@Nullable Activity activity) {
    this.activity = activity;
  }

  /**
   * Sets the activity when an activity is available. When the activity becomes unavailable, use
   * this method to set it to null.
   */
  public void setActivity(@Nullable Activity activity) {
    this.activity = activity;
  }

  void share(String text, String subject) {
    if (text == null || text.isEmpty()) {
      throw new IllegalArgumentException("Non-empty text expected");
    }

    Intent shareIntent = new Intent();
    shareIntent.setAction(Intent.ACTION_SEND);
    shareIntent.putExtra(Intent.EXTRA_TEXT, text);
    shareIntent.putExtra(Intent.EXTRA_SUBJECT, subject);
    shareIntent.setType("text/plain");
    Intent chooserIntent = Intent.createChooser(shareIntent, null /* dialog title optional */);
    if (activity != null) {
      activity.startActivity(chooserIntent);
    } else {
      chooserIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      activity.startActivity(chooserIntent);
    }
  }
}
