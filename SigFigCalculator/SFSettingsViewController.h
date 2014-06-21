//
//  SFSettingsViewController.h
//  SigFigCalculator
//
//  Created by Hunter Kyle Gearhart on 20/04/2014.
//  Copyright (c) 2014 University of Texas at Austin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface SFSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

// The UITableView populated with the application's settings
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
