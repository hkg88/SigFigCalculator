//
//  SFCustomTabBarViewController.m
//  SigFigCalculator
//
//  Created by Hunter Kyle Gearhart on 20/04/2014.
//  Copyright (c) 2014 University of Texas at Austin. All rights reserved.
//

#import "SFCustomTabBarViewController.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface SFCustomTabBarViewController ()

@end

@implementation SFCustomTabBarViewController

#pragma mark - Overridden UITabBarController Methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Change the tab bar item titles to the appropriate localized title values
  [self initializeViewControllers];
}

#pragma - Unique SFCustomTabBarViewController Methods

// Sets the names of each tab bar item
- (void)initializeViewControllers {
  
  NSString *storyboardName;
  if (IDIOM == IPAD) {
    storyboardName = @"MainStoryboard_iPad";
  } else {
    storyboardName = @"MainStoryboard_iPhone";
  }
  
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
  
  SFCalculatorViewController* SFCalculatorViewController =
            [storyboard instantiateViewControllerWithIdentifier:@"SFCalculator"];
  SFCounterViewController* SFCounterViewController =
            [storyboard instantiateViewControllerWithIdentifier:@"SFCounter"];
  SFConverterViewController* SFConverterViewController =
            [storyboard instantiateViewControllerWithIdentifier:@"SFConverter"];
  SFRulesViewController* SFRulesViewController =
            [storyboard instantiateViewControllerWithIdentifier:@"SFRules"];
  SFSettingsViewController* SFSettingsViewController =
            [storyboard instantiateViewControllerWithIdentifier:@"SFSettings"];
  
  SFBannerViewController* SFBannerCalculatorViewController = [[SFBannerViewController alloc] initWithinViewController:SFCalculatorViewController];
  SFBannerViewController* SFBannerCounterViewController = [[SFBannerViewController alloc] initWithinViewController:SFCounterViewController];
  SFBannerViewController* SFBannerConverterViewController = [[SFBannerViewController alloc] initWithinViewController:SFConverterViewController];
  SFBannerViewController* SFBannerRulesViewController = [[SFBannerViewController alloc] initWithinViewController:SFRulesViewController];
  SFBannerViewController* SFBannerSettingsViewController = [[SFBannerViewController alloc] initWithinViewController:SFSettingsViewController];
  
  self.viewControllers = @[SFBannerCalculatorViewController, SFBannerCounterViewController, SFBannerConverterViewController, SFBannerRulesViewController, SFBannerSettingsViewController];
  
  NSString *calculatorTitle = NSLocalizedString(@"Calculator", @"Calculator Tab Bar Item Title");
  [[self.viewControllers objectAtIndex:0] setTabBarItem:[[UITabBarItem alloc] initWithTitle:calculatorTitle image:[UIImage imageNamed:@"calculatorTabBarIcon"] selectedImage:nil]];
  
  NSString *counterTitle = NSLocalizedString(@"Counter", @"Counter Tab Bar Item Title");
  [[self.viewControllers objectAtIndex:1] setTabBarItem:[[UITabBarItem alloc] initWithTitle:counterTitle image:[UIImage imageNamed:@"counterTabBarIcon"] selectedImage:nil]];
  
  NSString *converterTitle = NSLocalizedString(@"Converter", @"Converter Tab Bar Item Title");
  [[self.viewControllers objectAtIndex:2] setTabBarItem:[[UITabBarItem alloc] initWithTitle:converterTitle image:[UIImage imageNamed:@"converterTabBarIcon"] selectedImage:nil]];
  
  NSString *rulesTitle = NSLocalizedString(@"Rules", @"SigFig Rules Tab Bar Item Title");
  [[self.viewControllers objectAtIndex:3] setTabBarItem:[[UITabBarItem alloc] initWithTitle:rulesTitle image:[UIImage imageNamed:@"rulesTabBarIcon"] selectedImage:nil]];
  
  NSString *settingsTitle = NSLocalizedString(@"Settings", @"SigFig Settings Tab Bar Item Title");
  [[self.viewControllers objectAtIndex:4] setTabBarItem:[[UITabBarItem alloc] initWithTitle:settingsTitle image:[UIImage imageNamed:@"settingsTabBarIcon"] selectedImage:nil]];
}
@end
