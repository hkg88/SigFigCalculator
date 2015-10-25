#import <Foundation/Foundation.h>
#import <StoreKit/Storekit.h>

@class SKProduct;

extern NSString *SFProductManagerTransactionStartedNotification;
extern NSString *SFProductManagerTransactionEndedNotification;

@interface SFProductManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

+ (instancetype)sharedManager;

- (void)makeProductRequestIfPaymentsPossible;

- (BOOL)canMakePayments;

- (void)purchaseAdRemovalProduct;

- (void)makeProductRequests;

@property (nonatomic, strong) SKProduct *removeAdsProduct;
@property (nonatomic) BOOL removeAdsProductPurchased;
@property (nonatomic, strong) NSString *removeAdsProductLocalizedTitle;
@property (nonatomic, strong) NSString *removeAdsProductLocalizedPrice;

@end
