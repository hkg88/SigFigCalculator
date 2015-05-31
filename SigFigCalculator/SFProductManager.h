#import <Foundation/Foundation.h>
#import <StoreKit/Storekit.h>

@class SKProduct;

@interface SFProductManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (instancetype)sharedManager;

- (BOOL)canMakePayments;

- (void)purchaseAdRemovalProduct;

- (NSString *)formattedPriceStringWithPrice:(NSNumber *)price;

@property (nonatomic, strong) SKProduct *removeAdsProduct;
@property (nonatomic) BOOL removeAdsProductPurchased;

@end
