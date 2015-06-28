#import "SFBannerViewManager.h"
#import "SFBannerViewController.h"
#import "SFConstants.h"
#import "SFUserDefaultsHelper.h"

@interface SFBannerViewManager()

@property (strong, nonatomic) ADBannerView *bannerView;
@property (strong, nonatomic) NSMutableSet *bannerViewControllers; //SFBannerViewController

@end

@implementation SFBannerViewManager

+ (SFBannerViewManager *)sharedInstance
{
    static SFBannerViewManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[SFBannerViewManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if ([[SFUserDefaultsHelper sharedManager] getBooleanForKey:kRemoveAdsProductIdentifier]) {
        return self;
    }
    
    if (self) {
        // On iOS 6 ADBannerView introduces a new initializer, use it when available.
        if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
            _bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
        } else {
            _bannerView = [[ADBannerView alloc] init];
        }
        _bannerView.delegate = self;
        _bannerViewControllers = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)addBannerViewController:(SFBannerViewController *)controller
{
    [self.bannerViewControllers addObject:controller];
}

- (void)removeBannerViewController:(SFBannerViewController *)controller
{
    [self.bannerViewControllers removeObject:controller];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if ([[SFUserDefaultsHelper sharedManager] getBooleanForKey:kRemoveAdsProductIdentifier]) {
        return;
    }
    
    NSLog(@"Loaded an iAd for the banner view.");
    for (SFBannerViewController *bannerViewController in self.bannerViewControllers) {
        [bannerViewController showBannerView];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if ([[SFUserDefaultsHelper sharedManager] getBooleanForKey:kRemoveAdsProductIdentifier]) {
        return;
    }
    
    NSLog(@"Failed to load an iAd for the banner view.");
    for (SFBannerViewController *bannerViewController in self.bannerViewControllers) {
        [bannerViewController hideBannerView];
    }
}

- (void)hideAllCurrentlyShownBannerViews
{
    for (SFBannerViewController *bannerViewController in self.bannerViewControllers) {
        [bannerViewController hideBannerView];
    }
}

@end

