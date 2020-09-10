// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTWKProgressionDelegate.h"

NSString *const keyPath = @"estimatedProgress";

@implementation FLTWKProgressionDelegate {
  FlutterMethodChannel *_methodChannel;
}

- (instancetype)initWithWebView:(WKWebView *)webView channel:(FlutterMethodChannel *)channel {
  self = [super init];
  if (self) {
    _methodChannel = channel;
    [webView addObserver:self
              forKeyPath:keyPath
                 options:NSKeyValueObservingOptionNew
                 context:nil];
  }
  return self;
}

- (void)stopObservingProgress:(WKWebView *)webView {
  [webView removeObserver:self forKeyPath:keyPath];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSKeyValueChangeKey, id> *)change
                       context:(void *)context {
  if ([keyPath isEqualToString:keyPath]) {
    NSNumber *newValue =
        change[NSKeyValueChangeNewKey] ?: 0;          // newValue is anywhere between 0.0 and 1.0
    int newValueAsInt = [newValue floatValue] * 100;  // Anywhere between 0 and 100
    [_methodChannel invokeMethod:@"onProgress"
                       arguments:@{@"progress" : [NSNumber numberWithInt:newValueAsInt]}];
  }
}

@end
