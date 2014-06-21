//
//  SFConverterViewController.h
//  SFCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SigFigCounter.h"
#import "SigFigConverter.h"

@interface SFConverterViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) SigFigCounter *sigFigCounter;
@property (strong, nonatomic) SigFigConverter *sigFigConverter;

@property (strong, nonatomic) IBOutlet UILabel *numberTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *numSigFigsTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultingNumberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultingNumberLabel;

- (IBAction)numberEntered:(UITextField *)sender;
- (IBAction)backgroundTapped:(UIControl *)sender;


@end
