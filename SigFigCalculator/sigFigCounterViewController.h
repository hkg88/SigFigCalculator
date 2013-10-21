//
//  sigFigCounterViewController.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/07.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SigFigCounter.h"

@interface sigFigCounterViewController : UIViewController <UITextFieldDelegate, ADBannerViewDelegate>

@property (strong, nonatomic) SigFigCounter *sigFigCounter;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsLabel;
@property (strong, nonatomic) IBOutlet UITabBarItem *tabBarTextCounter;

// Plain text that will have font given by Dynamic Font
@property (strong, nonatomic) IBOutlet UILabel *numberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsTextLabel;


// Advertisements
@property (strong, nonatomic) IBOutlet ADBannerView *adView;
@property BOOL bannerIsVisible;

- (IBAction)backgroundTapped:(UIControl *)sender;
- (IBAction)numberEntered:(UITextField *)sender;

@end
