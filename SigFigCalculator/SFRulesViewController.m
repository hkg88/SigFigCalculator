//
//  sigFigRulesViewController.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "SFRulesViewController.h"

@implementation SFRulesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Define the UIText view's contents
    self.rulesTextView.text = NSLocalizedString(@"Significant Figure Rules\n\nRules for Counting Significant Figures\n\n1. Zeros appearing between nonzero digits are significant\n\n2. Zeros appearing in front of nonzero digits are not significant\n\n3. Zeros at the end of a number and to the right of a decimal are significant\n\n4. Zeros at the end of a number but to the left of a decimal are either significant because they have been measured, or insignificant in the case that they are just placeholders\n\n5. All digits in a number written in Scientific Notation are significant\n\nRules for Calculating Using Significant Figures\n\nAddition and Subtraction\n\n1. The result should have the same number of digits after the decimal as the least accurate operand\n\nEx. 12.52 + 23.2 = 35.7\n\nMultiplication and Division\n\n1. The resulting product or quotient must have the same number of significant figures as the operand with the least number of significant figures\n\nEx. 12 x 1.55 = 19", @"SigFig Rules Explanation");
    self.rulesTextView.alwaysBounceVertical = YES;
    
    // Set up Dynamic Text with a listener
    self.rulesTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
    self.rulesTextView = nil;
    [super viewDidUnload];
}

// Clears out all of the labels and text fields when the view leaves the screen
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


# pragma Mark - Notification Center

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    self.rulesTextView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

@end
