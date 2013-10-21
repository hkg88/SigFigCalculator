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
@synthesize numberTextLabel = _numberTextLabel;
@synthesize numSigFigsTextLabel = _numSigFigsTextLabel;

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
    
    // Initialize the Ad Banner
    self.adView.delegate = self;
    self.bannerIsVisible = false;
    
    // Set up fonts and add a listener as to be able to adapt to changes
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsLabel.font = [UIFont fontWithName:@"Helvetica" size:125];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
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
        
        self.adView.frame = CGRectOffset(banner.frame, 0, -banner.frame.size.height-1);
        
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
        
        self.adView.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height+1);
        
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

#pragma mark -- Notification Center

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    //self.numSigFigsLabel.font = [UIFont fontWithName:UIFontTextStyleHeadline size:50];
}
@end
