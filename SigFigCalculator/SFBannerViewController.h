@interface SFBannerViewController : UIViewController

- (void)showBannerView;
- (void)hideBannerView;

@end

extern NSString *const BannerViewActionWillBegin;
extern NSString *const BannerViewActionDidFinish;