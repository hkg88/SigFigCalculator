//
//  SFSettingsViewController.m
//  SigFigCalculator
//
//  Created by Hunter Kyle Gearhart on 20/04/2014.
//  Copyright (c) 2014 University of Texas at Austin. All rights reserved.
//

#import "SFSettingsViewController.h"

@interface SFSettingsViewController ()

@end

@implementation SFSettingsViewController

// Settings Cell Content Tags and Layout Constants
#define SETTINGS_CELL_TITLE_TAG 100 // Tag of the label to hold the setting's name
#define SETTINGS_CELL_SUBTITLE_TAG 101 // tag of the label used to show the current setting
#define SETTINGS_CELL_IMAGE_TAG 102 // Tag of the UIImageView in the cell for setting's image

#define IMAGE_VIEW_OFFSET 10 // Places the login view 10 pixels off of the row's right edge
#define IMAGE_VIEW_SIZE_RATIO 5 // Makes the login view one-fifth of the row's width

// Support Cell Content Tags and Layout Constants
#define SUPPORT_CELL_TITLE_TAG 100 // Tag of the label to hold the setting's name
#define SUPPORT_CELL_IMAGE_TAG 101 // Tag of the UIImageView in the cell for setting's image

// Social Media Table View Contents
#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS 6

#define THEME_SETTINGS_ROW 0
#define INDICATOR_SETTINGS_ROW 1

#define SEPARATOR_ROW 2

#define REMOVE_ADS_ROW 3
#define WRITE_A_REVIEW_ROW 4
#define TELL_A_FRIEND_ROW 5

static NSString *settingsCellReuseId = @"SettingsCell";
static NSString *supportCellReuseId = @"SupportCell";
static NSString *separatorCellReuseId = @"SeparatorCell";

#pragma mark - Overridden UIViewController Methods

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  
  // Instantiate a listener for any changes to the UI options
  // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDisplayedSessionInformation:) name:self.fbSessionManager.SMFacebookSessionManagerSessionStateChangedNotification object:self.fbSessionManager];
  
}

#pragma mark - UITableViewDataSource Delegate Methods

// Builds and returns cells which have contents determined by the row they're on (i.e. the table's rows are static)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
  
  // Current row will contain a settings cell
  if(indexPath.row == THEME_SETTINGS_ROW || indexPath.row == INDICATOR_SETTINGS_ROW) {
    
    // Dequeue the appropriate settings cell and grab pointers to its UI elements
    cell = [tableView dequeueReusableCellWithIdentifier:settingsCellReuseId];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:SETTINGS_CELL_IMAGE_TAG];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:SETTINGS_CELL_TITLE_TAG];
    UILabel *subtitleLabel = (UILabel *)[cell viewWithTag:SETTINGS_CELL_SUBTITLE_TAG];
    
    // Display the current information for each individual setting
    if(indexPath.row == THEME_SETTINGS_ROW) {
      imageView.image = [UIImage imageNamed:@"AppIcon"];
      titleLabel.text = @"Theme";
      subtitleLabel.text = @"Black/Grey";
    } else if(indexPath.row == INDICATOR_SETTINGS_ROW) {
      imageView.image = [UIImage imageNamed:@"AppIcon"];
      titleLabel.text = @"Indicator";
      subtitleLabel.text = @"Single Underline";
    }
    
  // Current row will contain a support cell
  } else if(indexPath.row == REMOVE_ADS_ROW || indexPath.row == WRITE_A_REVIEW_ROW ||
            indexPath.row == TELL_A_FRIEND_ROW) {
    
    // Dequeue the appropriate support cell and grab pointers to its UI elements
    cell = [tableView dequeueReusableCellWithIdentifier:supportCellReuseId];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:SUPPORT_CELL_IMAGE_TAG];
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:SUPPORT_CELL_TITLE_TAG];
    
    // Display the current information for each individual setting
    if(indexPath.row == REMOVE_ADS_ROW) {
      imageView.image = [UIImage imageNamed:@"AppIcon"];
      titleLabel.text = @"Remove Ads";
    } else if(indexPath.row == WRITE_A_REVIEW_ROW) {
      imageView.image = [UIImage imageNamed:@"AppIcon"];
      titleLabel.text = @"Write a Review";
    } else if(indexPath.row == TELL_A_FRIEND_ROW) {
      imageView.image = [UIImage imageNamed:@"AppIcon"];
      titleLabel.text = @"Tell a Friend";
    }
    
    // Current row will contain a separator cell
  } else if(indexPath.row == SEPARATOR_ROW) {
    // Dequeue a separator cell
    cell = [tableView dequeueReusableCellWithIdentifier:separatorCellReuseId];
  }
  return cell;
}

// Indicates that there is only one section in the table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return NUMBER_OF_SECTIONS;
}

// Indicates that there are two rows in the single section of the table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return NUMBER_OF_ROWS;
}

// Returns the appropriate height for the cell at the given row
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 50;
}

// Called whenever the session state of one of the the SMSs changes
- (void)updateDisplayedSessionInformation:(NSNotification *)notification {
  // TODO : Reduce the scope of this reload to the particular elements which could change
  [self.tableView reloadData];
}

#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.row == THEME_SETTINGS_ROW) {
    // Allow the user to change the application's color scheme
  } else if(indexPath.row == INDICATOR_SETTINGS_ROW) {
    // Allow the user to change the way in which significant figures are marked
  } else if(indexPath.row == REMOVE_ADS_ROW) {
    // Send the user to the paid applications App Store URL
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:
      @"https://itunes.apple.com/us/app/significant-figures-calculator/id660032568?mt=8"]];
  } else if(indexPath.row == WRITE_A_REVIEW_ROW) {
    // Use a compose screen if possible? Or, send the user to the application' page
  } else if(indexPath.row == TELL_A_FRIEND_ROW) {
    // Display a pre-composed compose screen to be used to send an e-mail to a friend
    [self displayEmailComposeView];
  }
}

#pragma mark - SFSettingsViewController Unique Methods

// Displays an e-mail compose view with most information pre-filled in to be sent to
// a friend as an invitation to use the applicaiton
- (void)displayEmailComposeView {
  if ([MFMailComposeViewController canSendMail])
  {
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    
    mailer.mailComposeDelegate = self;
    
    [mailer setSubject:@"An Invitation to try Significant Figures Calculator"];
    
    NSString *emailBody = @"Hey! I've recently stumbled upon this great application! Want to give it a try?";
    [mailer setMessageBody:emailBody isHTML:NO];
    
    // Show the mail compilation sheet
    [self presentViewController:mailer animated:YES completion:nil];
  
  }
  else
  {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:@"Your device doesn't support sending e-mail"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
  }
}

#pragma mark - MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
  switch (result)
  {
    case MFMailComposeResultCancelled:
      NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
      break;
    case MFMailComposeResultSaved:
      NSLog(@"Mail saved: you saved the email message in the drafts folder.");
      break;
    case MFMailComposeResultSent:
      NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
      break;
    case MFMailComposeResultFailed:
      NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
      break;
    default:
      NSLog(@"Mail not sent.");
      break;
  }
  
  // Remove the mail compilation sheet
  [self dismissViewControllerAnimated:YES completion:nil];
}

@end
