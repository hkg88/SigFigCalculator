#import "SFProductManager.h"
#import "SFBannerViewManager.h"
#import "SFConstants.h"
#import "SFUserDefaultsHelper.h"

static const NSString *adRemovalProductIdentifier = @"com.kylegearhart.sigfigcalculator.removeadvertisements";

NSString *SFProductManagerTransactionStartedNotification = @"SFProductManagerTransactionStartedNotification";
NSString *SFProductManagerTransactionEndedNotification = @"SFProductManagerTransactionEndedNotification";

@interface SFProductManager ()
@end

@implementation SFProductManager

- (void)setRemoveAdsProductPurchased:(BOOL)value
{
    [[SFUserDefaultsHelper sharedManager] setBoolean:value forKey:kAdsRemovedUserDefaultBoolean];
}

- (BOOL)removeAdsProductPurchased
{
    return [[SFUserDefaultsHelper sharedManager] getBooleanForKey:kAdsRemovedUserDefaultBoolean];
}

+ (instancetype)sharedManager {
    static SFProductManager *sharedProductManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedProductManager = [[self alloc] init];
    });
    return sharedProductManager;
}

- (void)makeProductRequestIfPaymentsPossible
{
    if([self canMakePayments]){
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [self makeProductRequests];
    }
}

- (void)makeProductRequests
{
    NSSet *productIdentifiers = [NSSet setWithObject:adRemovalProductIdentifier];
    SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePayments
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseAdRemovalProduct
{
    SKPayment *payment = [SKPayment paymentWithProduct:self.removeAdsProduct];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (NSString *)formattedPriceStringWithPrice:(NSNumber *)price
{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:self.removeAdsProduct.priceLocale];
    return [numberFormatter stringFromNumber:self.removeAdsProduct.price];
}

- (void)notifyTransactionBegin
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SFProductManagerTransactionStartedNotification
                                                        object:self];
}

- (void)notifyTransactionEnd
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SFProductManagerTransactionEndedNotification
                                                        object:self];
}

#pragma mark - SKProductRequestDelegate Methods

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSUInteger count = [response.products count];
    if(count > 0) {
        NSLog(@"Products Available!");
        self.removeAdsProduct = [response.products objectAtIndex:0];
        self.removeAdsProductLocalizedTitle = self.removeAdsProduct.localizedTitle;
        self.removeAdsProductLocalizedPrice = [self formattedPriceStringWithPrice:self.removeAdsProduct.price];
    } else {
        NSLog(@"There's an issue with my product ID, double check it");
    }
}

#pragma mark - SKPurchaseQueueDelegate Methods

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing:
                [self notifyTransactionBegin];
                break;
            case SKPaymentTransactionStatePurchased:
                // Disable ads as the user has purchased the "Ad Removal" product
                self.removeAdsProductPurchased = YES;
                [[SFBannerViewManager sharedInstance] hideAllCurrentlyShownBannerViews];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self notifyTransactionEnd];
                break;
            case SKPaymentTransactionStateRestored:
                // Removes ads just as if the product was just purchased
                self.removeAdsProductPurchased = YES;
                [[SFBannerViewManager sharedInstance] hideAllCurrentlyShownBannerViews];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self notifyTransactionEnd];
                break;
            case SKPaymentTransactionStateFailed:
                // Called when the user cancels the current transaction
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                [self notifyTransactionEnd];
                break;
            case SKPaymentTransactionStateDeferred:
                // Allow for the StoreKit to handle the request, as it is indeterminate
                // as to when we will receive notification of a failed or successful purchase
                [self notifyTransactionEnd];
                break;
        }
    }
}


@end
