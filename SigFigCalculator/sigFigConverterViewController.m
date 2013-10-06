//
//  sigFigConverterViewController.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "sigFigConverterViewController.h"

#define NUMBER_TEXTFIELD_TAG 1
#define NUMSIGFIGS_TEXTFIELD_TAG 2

@implementation sigFigConverterViewController
@synthesize sigFigCounter = _sigFigCounter;
@synthesize sigFigConverter = _sigFigConverter;
@synthesize numberTextField = _numberTextField;
@synthesize numSigFigsTextField = _numSigFigsTextField;
@synthesize resultingNumberLabel = _resultingNumberLabel;
@synthesize tabBarTextConverter = _tabBarTextConverter;
@synthesize adView = _adView;

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define atLeastIOS6 [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0

#pragma mark -- View Lifecycle

- (void)awakeFromNib
{
    self.tabBarTextConverter.title = NSLocalizedString(@"Converter", @"Converter Tab Bar Title");
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.sigFigConverter = [[SigFigConverter alloc] init];
    self.numberTextField.delegate = self;
    self.numSigFigsTextField.delegate = self;
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
    self.sigFigConverter = nil;
    self.numberTextField = nil;
    self.numSigFigsTextField = nil;
    self.resultingNumberLabel = nil;
    self.tabBarTextConverter = nil;
    self.adView = nil;
    [super viewDidUnload];
}

// Clears out all of the labels and text fields when the view leaves the screen
- (void)viewDidDisappear:(BOOL)animated
{
    self.numberTextField.text = @"";
    self.numSigFigsTextField.text = @"";
    self.resultingNumberLabel.text = @"";
    [super viewDidDisappear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.adView removeFromSuperview];
    self.adView.delegate = nil;
    self.adView = nil;
    self.bannerIsVisible = NO;
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
    if (!self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
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

// Allows for the resignation of the text field's keyboard when editing is complete
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.numberTextField || textField == self.numSigFigsTextField) {
        [textField resignFirstResponder];
    }
    return NO;
}

// Initiated whenever the user is finished editing the current number
- (IBAction)numberEntered:(UITextField *)sender {
    // If both text fields have values, attempt to count and convert the sigFigs
    if(![self.numberTextField.text isEqualToString:@""] && ![self.numSigFigsTextField.text isEqualToString:@""]) {
        
        if(atLeastIOS6) {
            self.resultingNumberLabel.attributedText = [self.sigFigConverter convertNumSigFigs:self.numberTextField.text :self.numSigFigsTextField.text];
        } else {
            self.resultingNumberLabel.text = [[self.sigFigConverter convertNumSigFigs:self.numberTextField.text :self.numSigFigsTextField.text] string];
        }
    } else {
        self.resultingNumberLabel.text = @"";
    }
}

// If the background is tapped while a TextField is being edited, remove the keyboard
- (IBAction)backgroundTapped:(UIControl *)sender {
    [self.numberTextField resignFirstResponder];
    [self.numSigFigsTextField resignFirstResponder];
}

@end
