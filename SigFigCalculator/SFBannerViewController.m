#import <iAd/iAd.h>
#import "SFBannerViewController.h"
#import "SFBannerViewManager.h"

NSString * const BannerViewActionWillBegin = @"BannerViewActionWillBegin";
NSString * const BannerViewActionDidFinish = @"BannerViewActionDidFinish";

@interface SFBannerViewController()

@property (strong, nonatomic) UIViewController *contentViewController;

@end

@implementation SFBannerViewController

- (void)setContentViewController:(UIViewController *)contentViewController
{
    _contentViewController = contentViewController;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[SFBannerViewManager sharedInstance] addBannerViewController:self];
    }
    return self;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.contentViewController = segue.destinationViewController;
}

- (void)dealloc
{
    [[SFBannerViewManager sharedInstance] removeBannerViewController:self];
}

- (void)viewDidLayoutSubviews
{
    CGRect contentFrame = self.view.bounds, bannerFrame = CGRectZero;
    ADBannerView *bannerView = [SFBannerViewManager sharedInstance].bannerView;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
    NSString *contentSizeIdentifier;
    // If configured to support iOS <6.0, then we need to set the currentContentSizeIdentifier in order to resize the banner properly.
    // This continues to work on iOS 6.0, so we won't need to do anything further to resize the banner.
    if (contentFrame.size.width < contentFrame.size.height) {
        contentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    } else {
        contentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    }
    bannerFrame.size = [ADBannerView sizeFromBannerContentSizeIdentifier:contentSizeIdentifier];
#else
    // If configured to support iOS >= 6.0 only, then we want to avoid currentContentSizeIdentifier as it is deprecated.
    // Fortunately all we need to do is ask the banner for a size that fits into the layout area we are using.
    // At this point in this method contentFrame=self.view.bounds, so we'll use that size for the layout.
    bannerFrame.size = [bannerView sizeThatFits:contentFrame.size];
#endif
    
    if (bannerView.bannerLoaded) {
        contentFrame.size.height -= bannerFrame.size.height;
        bannerFrame.origin.y = contentFrame.size.height;
    } else {
        bannerFrame.origin.y = contentFrame.size.height;
    }
    self.contentViewController.view.frame = contentFrame;
    // We only want to modify the banner view itself if this view controller is actually visible to the user.
    // This prevents us from modifying it while it is being displayed elsewhere.
    if (self.isViewLoaded && (self.view.window != nil)) {
        [self.view addSubview:bannerView];
        bannerView.frame = bannerFrame;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
        bannerView.currentContentSizeIdentifier = contentSizeIdentifier;
#endif
    }
}

- (void)updateLayout
{
    [UIView animateWithDuration:0.25 animations:^{
        [self.view setNeedsLayout];
        [self.view layoutIfNeeded];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:[SFBannerViewManager sharedInstance].bannerView];
}

@end