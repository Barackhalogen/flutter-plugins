//
//  FIAObjectTranslator.h
//  in_app_purchase
//
//  Created by Chris Yang on 1/18/19.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SKProduct (Coder)

- (nullable NSDictionary *)toMap;

@end

@interface SKProductSubscriptionPeriod (Coder)

- (nullable NSDictionary *)toMap;

@end

@interface SKProductDiscount (Coder)

- (nullable NSDictionary *)toMap;

@end

@interface SKProductsResponse (Coder)

- (nullable NSDictionary *)toMap;

@end

NS_ASSUME_NONNULL_END
