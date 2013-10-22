//
//  sigFigCalculatorViewControllerViewController.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/02/08.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "sigFigCalculatorViewController.h"

@implementation sigFigCalculatorViewController
@synthesize display = _display;
@synthesize operatorDisplayLabel = _operatorDisplayLabel;
@synthesize sigFigCalculator = _sigFigCalculator;
@synthesize sigFigCounter = _sigFigCounter;
@synthesize sigFigConverter = _sigFigConverter;
@synthesize tabBarTextCalculator = _tabBarTextCalculator;
@synthesize nonClearButtons = _nonClearButtons;
@synthesize adView = _adView;
@synthesize bannerIsVisible = _bannerIsVisible;

enum{
    ADD = 1,
    SUBTRACT = 2,
    MULTIPLY = 3,
    DIVIDE = 4,
};

#define atLeastIOS6 [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0

#pragma mark -- View Lifecycle

- (void)awakeFromNib
{
    self.tabBarTextCalculator.title = NSLocalizedString(@"Calculator", @"Calculator Tab Bar Title");
    self.interstitialPresentationPolicy = ADInterstitialPresentationPolicyAutomatic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initialize];
    
    // Initialize the Ad Banner
    self.adView.delegate = self;
    self.bannerIsVisible = NO;
}

- (void)initialize
{
    // Initialize the View's SigFigCalculator Model
    self.sigFigCalculator = [[SigFigCalculator alloc] init];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.sigFigConverter = [[SigFigConverter alloc] init];
    self.display.text = @"0";
}

- (void) viewWillAppear:(BOOL)animated
{
    // Initialize the calculator
    self.sigFigCalculator = [[SigFigCalculator alloc] init];
    self.display.text = @"0";
}

- (void)viewDidUnload
{
    self.sigFigCalculator = nil;
    self.sigFigConverter = nil;
    self.sigFigCounter = nil;
    self.display = nil;
    self.operatorDisplayLabel = nil;
    self.nonClearButtons = nil;
    self.tabBarTextCalculator = nil;
    self.adView = nil;
    [super viewDidUnload];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.sigFigCalculator = nil;
    self.sigFigConverter = nil;
    self.sigFigCounter = nil;
    self.display.text = @"";
    self.operatorDisplayLabel.text = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [self initialize];
    [super viewDidAppear:animated];
}

// Only supports Portrait
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
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
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

// Handles entry of digits to become operands
- (IBAction)pressedDigit:(UIButton *)sender
{
    int digit = sender.tag;
    
    // If the first operand is undefined, define it with the new digit
    if(!self.sigFigCalculator.firstOperand) {
        self.sigFigCalculator.firstOperand = [[Operand alloc] initWithValue:[NSString stringWithFormat:@"%d", digit]];
        self.display.text = self.sigFigCalculator.firstOperand.value;
    // Reset the display if we need to for the new second operand
    } else if(self.sigFigCalculator.currOperator && !self.sigFigCalculator.secondOperand) {
        self.sigFigCalculator.secondOperand = [[Operand alloc] initWithValue:[NSString stringWithFormat:@"%d", digit]];
        self.display.text = self.sigFigCalculator.secondOperand.value;
    // Else simply append the new digit onto the current string
    } else {
        NSString *currNum;
        if(!self.sigFigCalculator.secondOperand) {
            currNum = self.sigFigCalculator.firstOperand.value;
            // Don't allow extra leading zeroes
            if(!([currNum isEqualToString:@"0"] && digit == 0)) {
                // Replace any single zero operands with their new value
                if([currNum isEqualToString:@"0"]) {
                    currNum = [NSString stringWithFormat:@"%d", digit];
                } else {
                    currNum = [currNum stringByAppendingString:[NSString stringWithFormat:@"%d", digit]];
                }
                self.sigFigCalculator.firstOperand.value = currNum;
                if(self.sigFigCalculator.firstOperand.containsDecimal) {
                    self.sigFigCalculator.firstOperand.precision++;
                }
                // If the operand is negative, negate it
                if(self.sigFigCalculator.firstOperand.isNegative) {
                    currNum = [@"-" stringByAppendingString:currNum];
                }
            }
        } else {
            currNum = self.sigFigCalculator.secondOperand.value;
            if(!([currNum isEqualToString:@"0"] && digit == 0)) {
                // Replace any single zero operands with their new value
                if([currNum isEqualToString:@"0"]) {
                    currNum = [NSString stringWithFormat:@"%d", digit];
                } else {
                    currNum = [currNum stringByAppendingString:[NSString stringWithFormat:@"%d", digit]];
                }
                self.sigFigCalculator.secondOperand.value = currNum;
                if(self.sigFigCalculator.secondOperand.containsDecimal) {
                    self.sigFigCalculator.secondOperand.precision++;
                }
                // If the operand is negative, negate it
                if(self.sigFigCalculator.secondOperand.isNegative) {
                    currNum = [@"-" stringByAppendingString:currNum];
                }
            }

        }
        self.display.text = currNum;
    }
}

// Clears the display and updates the SigFigCalculator object depending on the type of clear
- (IBAction)pressedClear:(UIButton *)sender;
{
    // Force the user to clear out the calculator after recording the result
    for(UIButton *button in self.nonClearButtons) {
        button.alpha = 1.0;
        button.enabled = YES;
    }
    self.sigFigCalculator.firstOperand = nil;
    self.sigFigCalculator.secondOperand = nil;
    self.display.text = @"0";
    self.sigFigCalculator.currOperator = nil;
    self.operatorDisplayLabel.text = @"";
}

// Using the tag of the Operation Button, sets the display label and changes to new Operator
- (IBAction)pressedOperator:(UIButton *)sender;
{
    // This is the case where the user initially presses an operator with the stock zero up
    // on the display
    if(self.sigFigCalculator.firstOperand == nil) {
        self.sigFigCalculator.firstOperand = [[Operand alloc]initWithValue:@"0"];
    }
    int newOperator = sender.tag;
    if(newOperator == ADD) {
        self.operatorDisplayLabel.text = @"+";
    } else if(newOperator == SUBTRACT) {
        self.operatorDisplayLabel.text = @"-";
    } else if(newOperator == MULTIPLY) {
        self.operatorDisplayLabel.text = @"x";
    } else if(newOperator == DIVIDE) {
        self.operatorDisplayLabel.text = @"/";
    }
    self.sigFigCalculator.currOperator = [NSNumber numberWithInt:newOperator];
}

// Adds a decimal to the appropriate operand if possible
- (IBAction)pressedDecimal:(UIButton *)sender {
    // Initialize Operand as decimal if this is it's first digit's value
    if(!self.sigFigCalculator.firstOperand) {
        self.sigFigCalculator.firstOperand = [[Operand alloc] initWithValue:@"0."];
        self.sigFigCalculator.firstOperand.containsDecimal = YES;
        self.display.text = self.sigFigCalculator.firstOperand.value;
    } else if (self.sigFigCalculator.currOperator && !self.sigFigCalculator.secondOperand) {
        self.sigFigCalculator.secondOperand = [[Operand alloc] initWithValue:@"0."];
        self.sigFigCalculator.secondOperand.containsDecimal = YES;
        self.display.text = self.sigFigCalculator.secondOperand.value;
    // Determine which operand we're looking at and add decimal if one not present
    } else {
        if(!self.sigFigCalculator.secondOperand) {
            if(!self.sigFigCalculator.firstOperand.containsDecimal) {
                self.sigFigCalculator.firstOperand.value = [self.sigFigCalculator.firstOperand.value stringByAppendingString:@"."];
                self.sigFigCalculator.firstOperand.containsDecimal = YES;
                self.display.text = self.sigFigCalculator.firstOperand.value;
                // Append back the lost negative sign
                if(self.sigFigCalculator.firstOperand.isNegative) {
                    self.display.text = [@"-" stringByAppendingString:self.display.text];
                }
            }
        } else {
            if(!self.sigFigCalculator.secondOperand.containsDecimal) {
                self.sigFigCalculator.secondOperand.value = [self.sigFigCalculator.secondOperand.value stringByAppendingString:@"."];
                self.sigFigCalculator.secondOperand.containsDecimal = YES;
                self.display.text = self.sigFigCalculator.secondOperand.value;
                // Append back the lost negative sign
                if(self.sigFigCalculator.secondOperand.isNegative) {
                    self.display.text = [@"-" stringByAppendingString:self.display.text];
                }
            }
        }
    }
}

// Carries out the current operation on the entered operands
- (IBAction)pressedEquals:(UIButton *)sender {
    if(self.sigFigCalculator.currOperator) {
        // Have the SigFigCalculator calculate the result
        // Only utilize attributedStrings if the device supports them
        if(atLeastIOS6) {
            self.display.attributedText = [self.sigFigCalculator calculateResult];
        } else {
            self.display.text = [[self.sigFigCalculator calculateResult] string];
        }
        
    
        // Force the user to clear out the calculator after recording the result
        for(UIButton *button in self.nonClearButtons) {
            button.alpha = 0.3;
            button.enabled = NO;
        }
    
        self.operatorDisplayLabel.text = @"";
    }
}

// Adds or deletes the '-' from the current number, effectively negating it
- (IBAction)pressedNegate:(id)sender
{
    if(!([self.display.text floatValue] == 0)) {
        if(!self.sigFigCalculator.secondOperand) {
            if(!self.sigFigCalculator.firstOperand.isNegative) {
                self.display.text = [@"-" stringByAppendingString:self.sigFigCalculator.firstOperand.value];
            } else {
                self.display.text = [self.sigFigCalculator.firstOperand.value substringFromIndex:0];
            }
            self.sigFigCalculator.firstOperand.isNegative = !self.sigFigCalculator.firstOperand.isNegative;
        } else {
            if(!self.sigFigCalculator.secondOperand.isNegative) {
                self.display.text = [@"-" stringByAppendingString:self.sigFigCalculator.secondOperand.value];
            } else {
                self.display.text = [self.sigFigCalculator.secondOperand.value substringFromIndex:0];
            }
            self.sigFigCalculator.secondOperand.isNegative = !self.sigFigCalculator.secondOperand.isNegative;
        }
    }
}

// Implements a backspace which can be used to correct typos while entering values
- (IBAction)pressedBackspace:(UIButton *)sender {
    // If the screen is simply a 0, a backspace can not be performed
    if(![self.display.text isEqual:@"0"]) {
        // We know that we're removing from the first operand
        if(!self.sigFigCalculator.secondOperand) {
            self.sigFigCalculator.firstOperand.value = [self.sigFigCalculator.firstOperand.value substringToIndex:(self.sigFigCalculator.firstOperand.value.length-1)];
            // Reset the value to zero if we're now left with a - or empty string
            if([self.sigFigCalculator.firstOperand.value isEqualToString:@""] ||
               [self.sigFigCalculator.firstOperand.value isEqualToString:@"-"]) {
                self.sigFigCalculator.firstOperand.isNegative = false;
                self.sigFigCalculator.firstOperand.value = @"0";
            }
            self.display.text = self.sigFigCalculator.firstOperand.value;
            // Update precision as well as whether the operand contains a decimal
            if([self.sigFigCalculator.firstOperand.value rangeOfString:@"."].location != NSNotFound) {
                self.sigFigCalculator.firstOperand.precision--;
                self.sigFigCalculator.firstOperand.containsDecimal = false;
            }
        } else {
            // We know that we're removing from the second operand
            self.sigFigCalculator.secondOperand.value = [self.sigFigCalculator.secondOperand.value substringToIndex:(self.sigFigCalculator.secondOperand.value.length-1)];
            // Reset the value to zero if we're now left with a - or empty string
            if([self.sigFigCalculator.secondOperand.value isEqualToString:@""] ||
                [self.sigFigCalculator.secondOperand.value isEqualToString:@"-"]) {
                self.sigFigCalculator.secondOperand.isNegative = false;
                self.sigFigCalculator.secondOperand.value = @"0";
            }
            self.display.text = self.sigFigCalculator.secondOperand.value;
            // Update precision as well as whether the operand contains a decimal
            if([self.sigFigCalculator.secondOperand.value rangeOfString:@"."].location != NSNotFound) {
                self.sigFigCalculator.secondOperand.precision--;
                self.sigFigCalculator.secondOperand.containsDecimal = false;
            }
        }
    }
}

@end
