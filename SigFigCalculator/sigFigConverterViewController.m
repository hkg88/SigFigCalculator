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
@synthesize numberTextLabel = _numberTextLabel;
@synthesize numberTextField = _numberTextField;
@synthesize numSigFigsTextLabel = _numSigFigsTextLabel;
@synthesize numSigFigsTextField = _numSigFigsTextField;
@synthesize resultingNumberTextLabel = _resultingNumberTextLabel;
@synthesize resultingNumberLabel = _resultingNumberLabel;
@synthesize tabBarTextConverter = _tabBarTextConverter;
@synthesize adView = _adView;

#define atLeastIOS6 [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0

#pragma mark -- View Lifecycle

- (void)awakeFromNib
{
    self.tabBarTextConverter.title = NSLocalizedString(@"Converter", @"Converter Tab Bar Title");
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.sigFigConverter = [[SigFigConverter alloc] init];
    self.numberTextField.delegate = self;
    self.numSigFigsTextField.delegate = self;
    
    // Initialize the Ad Banner
    self.adView.delegate = self;
    self.bannerIsVisible = NO;
    
    // Set-up Dynamic Text and a listener to react to any changes to it
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numberTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.resultingNumberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.resultingNumberLabel.font = [UIFont fontWithName:@"Helvetica" size:75];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    
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
        
        banner.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height-1);
        
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

// If an advertisement retrieval fails, push the banner offscreen
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        [UIView setAnimationDuration:0.25];
        
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height+1);
        
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
        self.resultingNumberLabel.text = @" ";
    }
}

// If the background is tapped while a TextField is being edited, remove the keyboard
- (IBAction)backgroundTapped:(UIControl *)sender {
    [self.numberTextField resignFirstResponder];
    [self.numSigFigsTextField resignFirstResponder];
}

#pragma mark -- Notification Center

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    // Set-up Dynamic Text and a listener to react to any changes to it
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numberTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.resultingNumberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

@end
