#import "SigFigCounter.h"
#import "SigFigConverter.h"
#import "SFBannerViewController.h"
#import "SFConverterViewController.h"

#define NUMBER_TEXTFIELD_TAG 1
#define NUMSIGFIGS_TEXTFIELD_TAG 2

@interface SFConverterViewController()

@property (strong, nonatomic) UIGestureRecognizer *keyboardDismissalTapGestureRecognizer;

@property (strong, nonatomic) IBOutlet UILabel *numberTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *numberTextField;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *numSigFigsTextField;
@property (strong, nonatomic) IBOutlet UILabel *resultingNumberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *resultingNumberLabel;
@property (strong, nonatomic) NSString *valueBeforeEdit;
@property (strong, nonatomic) UITextField *textFieldBeingEdited;

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
    
    self.keyboardDismissalTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(dismissKeyboard)];
    self.keyboardDismissalTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.keyboardDismissalTapGestureRecognizer];
    
    [self setupNumberEntryKeyboardAccessoryToolbar];
    [self setupNumSigFigsEntryKeyboardAccessoryToolbar];
    
    
}

- (void)setupNumberEntryKeyboardAccessoryToolbar
{
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(cancelPressed)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                         target:nil
                                                                         action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"+/-"
                                                            style:UIBarButtonItemStylePlain
                                                           target:self
                                                           action:@selector(changeSignPressed)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                         target:nil
                                                                         action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(numberEntered)]];
    [numberToolbar sizeToFit];
    self.numberTextField.inputAccessoryView = numberToolbar;
}

- (void)setupNumSigFigsEntryKeyboardAccessoryToolbar
{
    UIToolbar *numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = @[[[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:@selector(cancelPressed)],
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                         target:nil
                                                                         action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done"
                                                            style:UIBarButtonItemStyleDone
                                                           target:self
                                                           action:@selector(numberEntered)]];
    [numberToolbar sizeToFit];
    self.numSigFigsTextField.inputAccessoryView = numberToolbar;
}

- (void)changeSignPressed
{
    if ([self.numberTextField.text isEqualToString:@""]) {
        return;
    }
    
    NSMutableString *mutableText = self.numberTextField.text.mutableCopy;
    if ([self.numberTextField.text hasPrefix:@"-"]) {
        self.numberTextField.text = [self.numberTextField.text.mutableCopy substringWithRange:NSMakeRange(1, mutableText.length - 1)];
    } else {
        self.numberTextField.text = [@"-".mutableCopy stringByAppendingString:self.numberTextField.text];
    }
}

-(void)cancelPressed
{
    self.textFieldBeingEdited.text = self.valueBeforeEdit;
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.numberTextField || textField == self.numSigFigsTextField) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)numberEntered
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
    
    [self dismissKeyboard];
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

#pragma mark - UITextViewDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Store the current value prior to editing to be used if the user cancels their edit
    self.textFieldBeingEdited = textField;
    self.valueBeforeEdit = textField.text;
}

@end
