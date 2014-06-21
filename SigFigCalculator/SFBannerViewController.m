/*
 SFBannerViewController.m
 SFBannerViewController
 
 Created by Kyle Gearhart on 13/02/08.
 Copyright (c) 2013 Kyle Gearhart. All rights reserved.
 */

#import "SFBannerViewController.h"

NSString * const BannerViewAdvertisementReceived = @"BannerViewActionWillBegin";
NSString * const BannerViewFinishedDisplay = @"BannerViewActionDidFinish";

@interface SFBannerViewController ()
- (void)updateLayout; // Informs listening views that an ad has been retreived/displayed
@end

@interface SFBannerViewManager : NSObject <ADBannerViewDelegate>

@property (nonatomic, readonly) ADBannerView *bannerView;

+ (SFBannerViewManager *)sharedInstance;

- (void)addBannerViewController:(SFBannerViewController *)controller;
- (void)removeBannerViewController:(SFBannerViewController *)controller;

@end

@implementation SFBannerViewController {
  UIViewController *_contentController;
}

#define BOTTOM_MOST_VIEW 100

- (instancetype)initWithinViewController:(UIViewController *)contentController
{
  // If contentController is nil, -loadView is going to throw an exception when it
  // attempts to setup containment of a nil view controller.  Instead, throw the
  // exception here and make it obvious what is wrong.
  NSAssert(contentController != nil, @"Instantiating AdBanner in a nil view controller.");
    
  self = [super init];
  if (self != nil) {
    _contentController = contentController;
    [[SFBannerViewManager sharedInstance] addBannerViewController:self];
  }
  return self;
}

- (void)dealloc
{
  [[SFBannerViewManager sharedInstance] removeBannerViewController:self];
}

- (void)loadView
{
  UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
  // Setup containment of the _contentController.
  [self addChildViewController:_contentController];
  [contentView addSubview:_contentController.view];
  [_contentController didMoveToParentViewController:self];
    
  self.view = contentView;
}

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return [_contentController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}
#endif

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
  return [_contentController preferredInterfaceOrientationForPresentation];
}

- (NSUInteger)supportedInterfaceOrientations
{
  return [_contentController supportedInterfaceOrientations];
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
  
  // When an ad is loaded, shift the content up and display the ad beneath
  if (bannerView.bannerLoaded) {
    bannerFrame.origin.y = contentFrame.size.height - bannerFrame.size.height;
  } else {
    contentFrame.size.height += bannerFrame.size.height;
    bannerFrame.origin.y = contentFrame.size.height;
  }
  _contentController.view.frame = contentFrame;
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

// Causes the display or disappearance of the ad banner from the current content view
- (void)updateLayout
{
    [UIView animateWithDuration:0.25 animations:^{
        // Flag the view as needing to be relayed out
        [self.view setNeedsLayout];
        // Ask it to lay itself out if it is flagged
        [self.view layoutIfNeeded];
    }];
}

// Add the banner view when a content view containing one appears on-screen
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.view addSubview:[SFBannerViewManager sharedInstance].bannerView];
}

- (NSString *)title
{
    return _contentController.title;
}

@end

@implementation SFBannerViewManager {
    ADBannerView *_bannerView;
    NSMutableSet *_bannerViewControllers;
}

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
    if (self != nil) {
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
    [_bannerViewControllers addObject:controller];
}

- (void)removeBannerViewController:(SFBannerViewController *)controller
{
    [_bannerViewControllers removeObject:controller];
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Successfully loaded an advertisement");
    for (SFBannerViewController *bannerViewController in _bannerViewControllers) {
        [bannerViewController updateLayout];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Received an error while attempting to get an advertisement.");
    for (SFBannerViewController *bannerViewController in _bannerViewControllers) {
        [bannerViewController updateLayout];
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewAdvertisementReceived object:self];
    return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [[NSNotificationCenter defaultCenter] postNotificationName:BannerViewFinishedDisplay object:self];
}


@end
