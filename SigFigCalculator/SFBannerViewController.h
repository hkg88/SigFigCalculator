/*
  SFBannerViewController.h
  SFBannerViewController

  Created by Kyle Gearhart on 13/02/08.
  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
*/

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

extern NSString * const BannerViewAdvertisementReceived;
extern NSString * const BannerViewFinishedDisplay;

@interface SFBannerViewController : UIViewController

- (instancetype)initWithinViewController:(UIViewController *)contentController;

@end
