// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FLTWebViewFlutterInstanceManager.h"

@interface FLTWebViewFlutterInstanceManager ()
@property dispatch_queue_t lockQueue;
@property NSMapTable<NSNumber *, NSObject *> *identifiersToInstances;
@property NSMapTable<NSObject *, NSNumber *> *instancesToIdentifiers;
@end

@implementation FLTWebViewFlutterInstanceManager
- (instancetype)init {
  if (self) {
    self.lockQueue =
        dispatch_queue_create("FLTWebViewFlutterInstanceManager", DISPATCH_QUEUE_SERIAL);
    self.identifiersToInstances = [NSMapTable strongToStrongObjectsMapTable];
    self.instancesToIdentifiers = [NSMapTable strongToStrongObjectsMapTable];
  }
  return self;
}

- (void)addInstance:(nonnull NSObject *)instance withIdentifier:(long)identifier {
  NSAssert(instance && identifier >= 0, @"Instance must be nonnull and identifier must be >- 0.");
  dispatch_async(_lockQueue, ^{
    [self.instancesToIdentifiers setObject:@(identifier) forKey:instance];
    [self.identifiersToInstances setObject:instance forKey:@(identifier)];
  });
}

- (nullable NSObject *)removeInstanceWithIdentifier:(long)identifier {
  NSObject *__block instance = nil;
  dispatch_sync(_lockQueue, ^{
    instance = [self.identifiersToInstances objectForKey:@(identifier)];
    if (instance) {
      [self.identifiersToInstances removeObjectForKey:@(identifier)];
      [self.instancesToIdentifiers removeObjectForKey:instance];
    }
  });
  return instance;
}

- (long)removeInstance:(NSObject *)instance {
  NSAssert(instance, @"Instance must be nonnull.");
  NSNumber *__block identifierNumber = nil;
  dispatch_sync(_lockQueue, ^{
    identifierNumber = [self.instancesToIdentifiers objectForKey:instance];
    if (identifierNumber) {
      [self.identifiersToInstances removeObjectForKey:identifierNumber];
      [self.instancesToIdentifiers removeObjectForKey:instance];
    }
  });
  return identifierNumber ? identifierNumber.longValue : -1;
}

- (nullable NSObject *)instanceForIdentifier:(long)identifier {
  NSObject *__block instance = nil;
  dispatch_sync(_lockQueue, ^{
    instance = [self.identifiersToInstances objectForKey:@(identifier)];
  });
  return instance;
}

- (long)identifierForInstance:(nonnull NSObject *)instance {
  NSNumber *__block identifierNumber = nil;
  dispatch_sync(_lockQueue, ^{
    identifierNumber = [self.instancesToIdentifiers objectForKey:instance];
  });
  return identifierNumber ? identifierNumber.longValue : -1;
}
@end
