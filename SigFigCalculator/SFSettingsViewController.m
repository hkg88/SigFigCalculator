#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

#import "AppDelegate.h"
#import "SFSettingsViewController.h"
#import "SFUserDefaultsHelper.h"
#import "SFConstants.h"

@interface SFSettingsViewController ()

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SFUserDefaultsHelper *userDefaultsHelper;
@property (nonatomic, strong) SKProduct *removeAdsProduct;

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

// In-App Purchase Cell Content Tags and Layout Constants
#define IN_APP_PURCHASE_CELL_TITLE_TAG 100 // Tag of the label to hold the products name
#define IN_APP_PURCHASE_CELL_PRICE_TAG 101 // Tag of the label to hold the product's price

// Category Title Cell Content Tags
#define CATEGORY_CELL_TITLE_TAG 100

// Social Media Table View Contents
#define NUMBER_OF_SECTIONS 1
#define NUMBER_OF_ROWS 5

#define SUPPORT_CATEGORY_TITLE_ROW 0
#define WRITE_A_REVIEW_ROW 1
#define TELL_A_FRIEND_ROW 2
#define DISPLAY_SETTINGS_CATEGORY_TITLE_ROW 3
#define REMOVE_ADS_ROW 4

#define CONTENT_ROW_HEIGHT 50
#define CATEGORY_TITLE_ROW_HEIGHT 70

static NSString *settingsCellReuseId = @"SettingsCell";
static NSString *supportCellReuseId = @"SupportCell";
static NSString *blankCellReuseId = @"BlankCell";
static NSString *categoryTitleCellReuseId = @"CategoryTitleCell";
static NSString *inAppPurchaseCellReuseId = @"InAppPurchaseCell";

#pragma mark - Private

// Called when the user purchases the "Remove Ads" in-app purchase
- (void)removeAds {
    // Records an NSUserDefault boolean to ensure that this setting is persistant for multiple launches of the application
    [self.userDefaultsHelper setBoolean:YES forKey:kAdsRemovedUserDefaultBoolean];
}

#pragma mark - UITableViewDataSource Delegate

// Builds and returns cells which have contents determined by the row they're on (i.e. the table's rows are static)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell;
    
    // Dequeue the appropriate support cell and grab pointers to its UI elements
    if(indexPath.row == WRITE_A_REVIEW_ROW || indexPath.row == TELL_A_FRIEND_ROW) {
        cell = [tableView dequeueReusableCellWithIdentifier:supportCellReuseId];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:SUPPORT_CELL_TITLE_TAG];
        if(indexPath.row == WRITE_A_REVIEW_ROW) {
            titleLabel.text = NSLocalizedString(@"Write a Review", "Write a Review Cell Title");
        } else if(indexPath.row == TELL_A_FRIEND_ROW) {
            titleLabel.text = NSLocalizedString(@"Tell a Friend", "Tell a Friend Cell Title");
        }
    } else if(indexPath.row == REMOVE_ADS_ROW) {
        // Only request product meta-data to display here if the user is able to purchase in-App purchases
        if([SKPaymentQueue canMakePayments]){
            NSLog(@"User can make payments");
            // Display the "Remove Ads" In-App purchase in a table cell
            cell = [tableView dequeueReusableCellWithIdentifier:inAppPurchaseCellReuseId];
            UILabel *titleLabel = (UILabel *)[cell viewWithTag:IN_APP_PURCHASE_CELL_TITLE_TAG];
            UILabel *priceLabel = (UILabel *)[cell viewWithTag:IN_APP_PURCHASE_CELL_PRICE_TAG];
            
            // Add the localized title of the product as the cell's title
            titleLabel.text = self.removeAdsProduct.localizedTitle;
            
            // Format its price to be displayed for the locale of the App Store the user is on
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            [numberFormatter setLocale:self.removeAdsProduct.priceLocale];
            NSString *localizedPrice = [numberFormatter stringFromNumber:self.removeAdsProduct.price];
            // Only display the price if the In-App purchase has not been purchased yet
            if ([self.userDefaultsHelper getBooleanForKey:kAdsRemovedUserDefaultBoolean]) {
                priceLabel.text = NSLocalizedString(@"Purchased", "Indicator that the In-App purchase has been purchased");
            } else {
                priceLabel.text = (localizedPrice) ? [NSString stringWithFormat:@"%@", localizedPrice] : @"";
            }
        } else {
            // Return a normal placeholder cell as the user can not make any purchases
            NSLog(@"User cannot make payments due to parental controls");
            cell = [tableView dequeueReusableCellWithIdentifier:blankCellReuseId];
        }
    } else if(indexPath.row == DISPLAY_SETTINGS_CATEGORY_TITLE_ROW) {
        cell = [tableView dequeueReusableCellWithIdentifier:categoryTitleCellReuseId];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:CATEGORY_CELL_TITLE_TAG];
        titleLabel.text = NSLocalizedString(@"Display", "Display Settings Category Title");
    } else if(indexPath.row == SUPPORT_CATEGORY_TITLE_ROW) {
        cell = [tableView dequeueReusableCellWithIdentifier:categoryTitleCellReuseId];
        UILabel *titleLabel = (UILabel *)[cell viewWithTag:CATEGORY_CELL_TITLE_TAG];
        titleLabel.text = NSLocalizedString(@"Support", "Support Settings Category Title");
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

// Called whenever the session state of one of the the SMSs changes
- (void)updateDisplayedSessionInformation:(NSNotification *)notification {
  // TODO : Reduce the scope of this reload to the particular elements which could change
  [self.tableView reloadData];
}

#pragma mark - SKProductRequestDelegate Methods

// Callback function which is notified when a response is received containing information about In-App products
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSUInteger count = [response.products count];
    if(count > 0) {
        NSLog(@"Products Available!");
        self.removeAdsProduct = [response.products objectAtIndex:0];
        [self.tableView reloadData];
    } else {
        NSLog(@"There's an issue with my product ID, double check it");
    }
}

#pragma mark - SKPurchaseQueueDelegate Methods

// Callback which is first called whenever an SKProductsRequest is initiated, and serves as a way
// to keep track of where in the purchasing process we are
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing:
                break;
            case SKPaymentTransactionStatePurchased:
                // Disable ads as the user has purchased the "Ad Removal" product
                [self removeAds];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // Reload the table data to reflect that the "Ad Removal" product has been purchased
                [self.tableView reloadData];
                break;
            case SKPaymentTransactionStateRestored:
                // Removes ads just as if the product was just purchased
                [self removeAds];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                // Reload the table data to reflect that the "Ad Removal" product has been purchased
                [self.tableView reloadData];
                break;
            case SKPaymentTransactionStateFailed:
                // Called when the user cancels the current transaction
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateDeferred:
                // Allow for the StoreKit to handle the request, as it is indeterminate
                // as to when we will receive notification of a failed or successful purchase
                break;
        }
    }
}

#pragma mark - UITableViewDelegate Methods

// Callback function which is called when a user selects a row of the table view
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if(indexPath.row == REMOVE_ADS_ROW) {
      // Begin the payment process for the In-App purchase if it hasn't been bought, and the
      // user is able to pay for purchases
      if ([SKPaymentQueue canMakePayments] && ![self.userDefaultsHelper getBooleanForKey:kAdsRemovedUserDefaultBoolean]) {
          SKPayment *payment = [SKPayment paymentWithProduct:self.removeAdsProduct];
          [[SKPaymentQueue defaultQueue] addPayment:payment];
      }
  } else if(indexPath.row == WRITE_A_REVIEW_ROW) {
    // Use a compose screen if possible? Or, send the user to the application's Store page
  } else if(indexPath.row == TELL_A_FRIEND_ROW) {
    // Display a pre-composed compose screen to be used to send an e-mail to a friend
    [self displayEmailComposeView];
  }
}

// Callback function which will return the height of the given row's cell
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == WRITE_A_REVIEW_ROW || indexPath.row == TELL_A_FRIEND_ROW || indexPath.row == REMOVE_ADS_ROW) {
        return CONTENT_ROW_HEIGHT;
    } else {
        return CATEGORY_TITLE_ROW_HEIGHT;
    }
}

#pragma mark - SFSettingsViewController Unique Methods

// Displays an e-mail compose view with most information pre-filled in to be sent to
// a friend as an invitation to use the applicaiton
- (void)displayEmailComposeView {
  if ([MFMailComposeViewController canSendMail]) {
      // Initialize and define the content for the mail compose view controller which will be displayed to the user
    MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
    mailer.mailComposeDelegate = self;
    [mailer setSubject:@"An Invitation to try Significant Figures Calculator"];
    NSString *emailBody = @"Hey! I've recently stumbled upon this great application! Want to give it a try?";
    [mailer setMessageBody:emailBody isHTML:NO];
    
    // Show the mail composition view controller
    [self presentViewController:mailer animated:YES completion:nil];
      
  } else {
      // In the event that mail isn't set up on the device, show an alert informing the user of this
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                    message:@"Your device doesn't support sending e-mail"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles: nil];
    [alert show];
  }
}

@end
