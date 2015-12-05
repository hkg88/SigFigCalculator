#import <iAd/iAd.h>
#import "SFBannerViewController.h"
#import "SFBannerViewManager.h"
#import "SFProductManager.h"

@interface SFBannerViewController()
@property (strong, nonatomic) ADBannerView *bannerView;
@property (nonatomic) BOOL bannerViewIsDisplayed;
@property (strong, nonatomic) UIViewController *contentViewController;
@property (strong, nonatomic) NSLayoutConstraint *contentViewBottomLayoutConstraint;
@end

@implementation SFBannerViewController

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


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([SFProductManager sharedManager].removeAdsProductPurchased) {
        return ;
    }
    
    if (![self.view.subviews containsObject:self.bannerView]) {
        [self.bannerView setTranslatesAutoresizingMaskIntoConstraints:NO];

        CGRect offBottomScreenFrame = CGRectMake(0.0f, CGRectGetHeight(self.contentViewController.view.frame) + self.bannerView.bounds.size.height, self.bannerView.bounds.size.width, self.bannerView.bounds.size.height);
        self.bannerView.frame = offBottomScreenFrame;

        [self.view addSubview:self.bannerView];

        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.bannerView
                                                              attribute:NSLayoutAttributeTop
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.contentViewController.view
                                                              attribute:NSLayoutAttributeBottom
                                                             multiplier:1.0f
                                                               constant:0.0f]];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *contentView = self.contentViewController.view;
    [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    self.contentViewBottomLayoutConstraint =  [NSLayoutConstraint constraintWithItem:contentView
                                                                           attribute:NSLayoutAttributeBottom
                                                                           relatedBy:NSLayoutRelationEqual
                                                                              toItem:self.view
                                                                           attribute:NSLayoutAttributeBottom
                                                                          multiplier:1.0f
                                                                            constant:0.0f];
    [self.view addConstraint:self.contentViewBottomLayoutConstraint];
    
    if (![SFProductManager sharedManager].removeAdsProductPurchased) {
        self.bannerView = [SFBannerViewManager sharedInstance].bannerView;
    }
}


- (void)dealloc
{
    [[SFBannerViewManager sharedInstance] removeBannerViewController:self];
}

- (void)hideBannerView
{
    if (self.bannerViewIsDisplayed) {
        [self.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.contentViewBottomLayoutConstraint.constant = 0.0;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.bannerViewIsDisplayed = NO;
        }];
    }
}

- (void)showBannerView
{
    if (!self.bannerViewIsDisplayed) {
        [self.view layoutIfNeeded];
        
        [UIView animateWithDuration:0.25 animations:^{
            self.contentViewBottomLayoutConstraint.constant = -50.0f;
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.bannerViewIsDisplayed = YES;
        }];
    }
}

@end