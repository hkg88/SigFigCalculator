//
//  sigFigConverterViewController.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SigFigCounter.h"
#import "SigFigConverter.h"

@interface sigFigConverterViewController : UIViewController <UITextFieldDelegate, ADBannerViewDelegate>

@property (strong, nonatomic) SigFigCounter *sigFigCounter;
@property (strong, nonatomic) SigFigConverter *sigFigConverter;

@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UITextField *numSigFigsTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultingNumberLabel;
@property (strong, nonatomic) IBOutlet UITabBarItem *tabBarTextConverter;

// Advertisements
@property (strong, nonatomic) ADBannerView *adView;
@property BOOL bannerIsVisible;

- (IBAction)numberEntered:(UITextField *)sender;
- (IBAction)backgroundTapped:(UIControl *)sender;


@end
