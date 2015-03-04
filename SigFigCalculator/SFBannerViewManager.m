#import "SFBannerViewManager.h"
#import "SFBannerViewController.h"

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
    for (SFBannerViewController *bannerViewController in self.bannerViewControllers) {
        [bannerViewController updateLayout];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    for (SFBannerViewController *bannerViewController in self.bannerViewControllers) {
        [bannerViewController updateLayout];
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionWillBegin object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewActionDidFinish object:self];
}

@end

