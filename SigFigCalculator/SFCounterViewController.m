#import "SFCounterViewController.h"
#import "SigFigCounter.h"
#import "SFBannerViewController.h"

@interface SFCounterViewController()

@property (strong, nonatomic) UIGestureRecognizer *keyboardDismissalTapGestureRecognizer;

@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsLabel;
@property (strong, nonatomic) IBOutlet UILabel *numberTextLabel;
@property (strong, nonatomic) IBOutlet UILabel *numSigFigsTextLabel;
@property (strong, nonatomic) NSString *valueBeforeEdit;

@property (strong, nonatomic) SigFigCounter *sigFigCounter;

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
    
    self.keyboardDismissalTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                         action:@selector(numberEntered)];
    self.keyboardDismissalTapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:self.keyboardDismissalTapGestureRecognizer];
    
    [self setupKeyboardAccessoryToolbar];
}

- (void)setupKeyboardAccessoryToolbar
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
    self.textField.inputAccessoryView = numberToolbar;
}

- (void)changeSignPressed
{
    if ([self.textField.text isEqualToString:@""]) {
        return;
    }
    
    NSMutableString *mutableText = self.textField.text.mutableCopy;
    if ([self.textField.text hasPrefix:@"-"]) {
        self.textField.text = [self.textField.text.mutableCopy substringWithRange:NSMakeRange(1, mutableText.length - 1)];
    } else {
        self.textField.text = [@"-".mutableCopy stringByAppendingString:self.textField.text];
    }
}

-(void)cancelPressed
{
    self.textField.text = self.valueBeforeEdit;
    [self dismissKeyboard];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)numberEntered
{
    // Only attempt and count the SigFigs of a non-empty NSString
    if(![self.textField.text isEqualToString:@""]) {
        int numSigFigs = [self.sigFigCounter countSigFigs:self.textField.text];
        // The SigFigCounter will return -1 if the inputted number isn't valid
        if(numSigFigs >= 0) {
            self.numSigFigsLabel.text = [NSString stringWithFormat:@"%d", numSigFigs];
        } else {
            self.numSigFigsLabel.text = NSLocalizedString(@"Please enter a valid integer or float", @"Counter Invalid Input");
        }
    } else {
        self.numSigFigsLabel.text = @"";
    }
    
    [self dismissKeyboard];
}

- (void)preferredContentSizeChanged:(NSNotification *)notification
{
    self.numberTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.numSigFigsTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
}

#pragma mark - UITextViewDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    // Store the current value prior to editing to be used if the user cancels their edit
    self.valueBeforeEdit = self.textField.text;
}

@end
