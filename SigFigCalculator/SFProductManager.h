#import <Foundation/Foundation.h>
#import <StoreKit/Storekit.h>

@class SKProduct;

@interface SFProductManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (instancetype)sharedManager;

- (BOOL)canMakePayments;

- (void)purchaseAdRemovalProduct;

- (void)makeProductRequests;

@property (nonatomic, strong) SKProduct *removeAdsProduct;
@property (nonatomic) BOOL removeAdsProductPurchased;
@property (nonatomic, strong) NSString *removeAdsProductLocalizedTitle;
@property (nonatomic, strong) NSString *removeAdsProductLocalizedPrice;

@end
