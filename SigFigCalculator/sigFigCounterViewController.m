//
//  sigFigCounterViewController.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/07.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "sigFigCounterViewController.h"

@implementation sigFigCounterViewController
@synthesize sigFigCounter = _sigFigCounter;
@synthesize textField = _textField;
@synthesize tabBarTextCounter = _tabBarTextCounter;
@synthesize numSigFigsLabel = _numSigFigsLabel;
@synthesize adView = _adView;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#pragma mark -- View Lifecycle

- (void)awakeFromNib
{
    self.tabBarTextCounter.title = NSLocalizedString(@"Counter", @"Counter Tab Bar Title");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.textField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    // Initialize the Ad Banner
    self.adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    self.adView.requiredContentSizeIdentifiers = [NSSet setWithObject: ADBannerContentSizeIdentifierPortrait];
    self.adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierPortrait;
    // Places the banner above the tab bar
    if (IS_IPHONE_5) {
        self.adView.frame = CGRectMake(0, 450+100, self.adView.frame.size.width, self.adView.frame.size.height);
    } else {
        self.adView.frame = CGRectMake(0, 360+100, self.adView.frame.size.width, self.adView.frame.size.height);
    }
    
    self.adView.delegate = self;
    self.adView.autoresizesSubviews = YES;
    self.adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    self.bannerIsVisible = false;
    [self.view addSubview:self.adView];
}

- (void)viewDidUnload
{
    self.sigFigCounter = nil;
    self.numSigFigsLabel = nil;
    self.textField = nil;
    self.tabBarTextCounter = nil;
    self.adView = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.adView removeFromSuperview];
    self.adView.delegate = nil;
    self.adView = nil;
    self.bannerIsVisible = NO;
}

// Clears out the text information when the view leaves the screen
- (void)viewDidDisappear:(BOOL)animated
{
    self.textField.text = @"";
    self.numSigFigsLabel.text = @"";
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -- iAd Lifecycle

// Brings the banner into view
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:0.25];
        
        banner.frame = CGRectOffset(banner.frame, 0, -100);
        
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

// If an advertisement retrieval fails, push the banner offscreen
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        [UIView setAnimationDuration:0.25];
        
        banner.frame = CGRectOffset(banner.frame, 0, 100);
        
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

// If the banner is tapped, don't leave the app and just allow the ad to cover the screen
- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

// Placeholder for processing which needs to be done when the app is brought back from the background
- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    
}

#pragma mark -- View Behavior Methods

// Initiated whenever the user is finished editing the current number
- (IBAction)numberEntered:(UITextField *)sender {
    // Only attempt and count the SigFigs of a non-empty NSString
    if(![self.textField.text isEqualToString:@""]) {
        int numSigFigs = [self.sigFigCounter countSigFigs:sender.text];
        // The SigFigCounter will return -1 if the inputted number isn't valid
        if(numSigFigs >= 0) {
            self.numSigFigsLabel.text = [NSString stringWithFormat:@"%d", numSigFigs];
        } else {
            self.numSigFigsLabel.text = NSLocalizedString(@"Please enter a valid integer or float", @"Counter Invalid Input");
        }
    } else {
        self.numSigFigsLabel.text = @"";
    }
}

// Background was tapped, exit the keyboard if it's present
- (void)backgroundTapped:(UIControl *)sender {
    [self.textField resignFirstResponder];
}


// Allows for the resignation of the text field's keyboard when editing is complete
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    return NO;
}
@end
