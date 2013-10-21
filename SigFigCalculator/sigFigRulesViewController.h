//
//  sigFigRulesViewController.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface sigFigRulesViewController : UIViewController <ADBannerViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *rulesTextView;
@property (strong, nonatomic) IBOutlet UITabBarItem *tabBarTextRules;

// Advertisements
@property (strong, nonatomic) IBOutlet ADBannerView *adView;
@property BOOL bannerIsVisible;

@end
