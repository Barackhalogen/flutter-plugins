// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <AVFoundation/AVFoundation.h>

/**
 * Note: https://stackoverflow.com/questions/64161544
 * `AVAssetTrack.preferredTransform` can have wrong `tx` and `ty`
 * on iOS 14 and above. This function provides a standardized transform
 * according to the orientation of the track.
 */
CGAffineTransform FLTGetStandardizedTransformForTrack(AVAssetTrack *track);
