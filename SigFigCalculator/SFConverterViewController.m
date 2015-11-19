#import "SigFigCounter.h"
#import "SigFigConverter.h"
#import "SFBannerViewController.h"
#import "SFConverterViewController.h"

#define NUMBER_TEXTFIELD_TAG 1
#define NUMSIGFIGS_TEXTFIELD_TAG 2

@interface SFConverterViewController()

@property (strong, nonatomic) IBOutlet UILabel *numberTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *numSigFigsTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultingNumberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultingNumberLabel;

@property (strong, nonatomic) SigFigCounter *sigFigCounter;
@property (strong, nonatomic) SigFigConverter *sigFigConverter;

@end

@implementation SFConverterViewController

#pragma mark -- View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.sigFigConverter = [[SigFigConverter alloc] init];
    self.numberTextField.delegate = self;
    self.numSigFigsTextField.delegate = self;
    
    // Set-up Dynamic Text and a listener to react to any changes to it
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numberTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.resultingNumberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.resultingNumberLabel.font = [UIFont fontWithName:@"Helvetica" size:75];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.numberTextField || textField == self.numSigFigsTextField) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (IBAction)numberEntered:(UITextField *)sender
{
    // If both text fields have values, attempt to count and convert the sigFigs
    if(![self.numberTextField.text isEqualToString:@""] && ![self.numSigFigsTextField.text isEqualToString:@""]) {
        if(atLeastIOS6) {
            self.resultingNumberLabel.attributedText = [self.sigFigConverter convertNumSigFigs:self.numberTextField.text to:self.numSigFigsTextField.text];
        } else {
            self.resultingNumberLabel.text = [[self.sigFigConverter convertNumSigFigs:self.numberTextField.text to:self.numSigFigsTextField.text] string];
        }
    } else {
        self.resultingNumberLabel.text = @" ";
    }
}

- (IBAction)backgroundTapped:(UIControl *)sender
{
    [self.numberTextField resignFirstResponder];
    [self.numSigFigsTextField resignFirstResponder];
}

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    // Set-up Dynamic Text and a listener to react to any changes to it
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numberTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.resultingNumberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(preferredContentSizeChanged:) name:UIContentSizeCategoryDidChangeNotification object:nil];
}

@end
