#import <iAd/iAd.h>
@class SFBannerViewController;

@interface SFBannerViewManager : NSObject <ADBannerViewDelegate>

@property (nonatomic, readonly) ADBannerView *bannerView;

+ (SFBannerViewManager *)sharedInstance;
- (void)addBannerViewController:(SFBannerViewController *)controller;
- (void)removeBannerViewController:(SFBannerViewController *)controller;

@end

