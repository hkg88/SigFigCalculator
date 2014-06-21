//
//  SFCounterViewController.h
//  SFCalculator
//
//  Created by Kyle Gearhart on 13/03/07.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigFigCounter.h"

@interface SFCounterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) SigFigCounter *sigFigCounter;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsLabel;

// Plain text that will have font given by Dynamic Font
@property (strong, nonatomic) IBOutlet UILabel *numberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsTextLabel;

- (IBAction)backgroundTapped:(UIControl *)sender;
- (IBAction)numberEntered:(UITextField *)sender;

@end
