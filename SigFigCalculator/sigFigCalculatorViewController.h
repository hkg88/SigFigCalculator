//
//  sigFigCalculatorViewControllerViewController.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/02/08.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Math.h"
#import "SigFigCalculator.h"
#import "SigFigCounter.h"
#import "SigFigConverter.h"

@interface sigFigCalculatorViewController : UIViewController <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *nonClearButtons;

@property (strong, nonatomic) SigFigCalculator *sigFigCalculator;
@property (strong, nonatomic) IBOutlet UILabel *display;
@property (strong, nonatomic) IBOutlet UILabel *operatorDisplayLabel;

@property (strong, nonatomic) SigFigCounter *sigFigCounter;
@property (strong, nonatomic) SigFigConverter *sigFigConverter;
@property (strong, nonatomic) IBOutlet UITabBarItem *tabBarTextCalculator;

// Advertisements
@property (strong, nonatomic) ADBannerView *adView;
@property BOOL bannerIsVisible;

- (IBAction)pressedDigit:(UIButton *)sender;
- (IBAction)pressedClear:(UIButton *)sender;
- (IBAction)pressedOperator:(UIButton *)sender;
- (IBAction)pressedDecimal:(UIButton *)sender;
- (IBAction)pressedEquals:(id)sender;
- (IBAction)pressedNegate:(id)sender;
- (IBAction)pressedBackspace:(UIButton *)sender;


@end
