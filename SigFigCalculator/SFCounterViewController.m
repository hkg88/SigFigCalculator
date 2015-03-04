#import "SFCounterViewController.h"
#import "SigFigCounter.h"
#import "SFBannerViewController.h"

@interface SFCounterViewController()

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsTextLabel;

@property (strong, nonatomic) SigFigCounter *sigFigCounter;

- (IBAction)backgroundTapped:(UIControl *)sender;
- (IBAction)numberEntered:(UITextField *)sender;

@end

@implementation SFCounterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.textField.delegate = self;
    
    // Set up fonts and add a listener as to be able to adapt to changes
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsLabel.font = [UIFont fontWithName:@"Helvetica" size:125];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    self.textField.text = @"";
    self.numSigFigsLabel.text = @"";
    [super viewDidDisappear:animated];
}

- (IBAction)numberEntered:(UITextField *)sender
{
    // Only attempt and count the SigFigs of a non-empty NSString
    if(![self.textField.text isEqualToString:@""]) {
        int numSigFigs = [self.sigFigCounter countSigFigs:sender.text];
        // The SigFigCounter will return -1 if the inputted number isn't valid
        if(numSigFigs >= 0) {
            self.numSigFigsLabel.text = [NSString stringWithFormat:@"%d", numSigFigs];
        } else {
            self.numSigFigsLabel.text = NSLocalizedString(@"Please enter a valid integer or float", @"Counter Invalid Input");
        }
    } else {
        self.numSigFigsLabel.text = @"";
    }
}

#pragma mark UITextFieldDelegate

- (void)backgroundTapped:(UIControl *)sender
{
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.textField) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

@end
