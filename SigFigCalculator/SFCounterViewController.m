//
//  sigFigCounterViewController.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/07.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "SFCounterViewController.h"

@implementation SFCounterViewController

#pragma mark -- View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.textField.delegate = self;
    
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
}
@end
