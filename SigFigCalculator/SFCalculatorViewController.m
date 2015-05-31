#import "SFCalculatorViewController.h"
#import "Math.h"
#import "SigFigCalculator.h"
#import "SigFigCounter.h"
#import "SigFigConverter.h"
#import "SFBannerViewController.h"

@interface SFCalculatorViewController()

@property (strong, nonatomic) IBOutlet UILabel *display;
@property (strong, nonatomic) IBOutlet UILabel *operatorDisplayLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *nonClearButtons;

@property (strong, nonatomic) SigFigCounter *sigFigCounter;
@property (strong, nonatomic) SigFigConverter *sigFigConverter;
@property (strong, nonatomic) SigFigCalculator *sigFigCalculator;

@end

@implementation SFCalculatorViewController

enum {
    ADD = 1,
    SUBTRACT = 2,
    MULTIPLY = 3,
    DIVIDE = 4,
};

#pragma mark -- UIViewController Lifecycle Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize the View's SigFigCalculator Model
    self.sigFigCalculator = [[SigFigCalculator alloc] init];
    self.sigFigCounter = [[SigFigCounter alloc] init];
    self.sigFigConverter = [[SigFigConverter alloc] init];
    self.display.text = @"0";
}

#pragma mark -- Private Methods

- (IBAction)pressedDigit:(UIButton *)sender
{
    NSInteger digit = sender.tag;
    
    // If the first operand is undefined, define it with the new digit
    if(!self.sigFigCalculator.firstOperand) {
        self.sigFigCalculator.firstOperand = [[Operand alloc] initWithValue:[NSString stringWithFormat:@"%ld", (long)digit]];
        self.display.text = self.sigFigCalculator.firstOperand.value;
    // Reset the display if we need to for the new second operand
    } else if(self.sigFigCalculator.currOperator && !self.sigFigCalculator.secondOperand) {
        self.sigFigCalculator.secondOperand = [[Operand alloc] initWithValue:[NSString stringWithFormat:@"%ld", (long)digit]];
        self.display.text = self.sigFigCalculator.secondOperand.value;
    // Else simply append the new digit onto the current string
    } else {
        NSString *currNum;
        if(!self.sigFigCalculator.secondOperand) {
            currNum = self.sigFigCalculator.firstOperand.value;
            // Don't allow extra leading zeroes
            if(!([currNum isEqualToString:@"0"] && digit == 0)) {
                // Replace any single zero operands with their new value
                if([currNum isEqualToString:@"0"]) {
                    currNum = [NSString stringWithFormat:@"%ld", (long)digit];
                } else {
                    currNum = [currNum stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)digit]];
                }
                self.sigFigCalculator.firstOperand.value = currNum;
                if(self.sigFigCalculator.firstOperand.containsDecimal) {
                    self.sigFigCalculator.firstOperand.precision++;
                }
                // If the operand is negative, negate it
                if(self.sigFigCalculator.firstOperand.isNegative) {
                    currNum = [@"-" stringByAppendingString:currNum];
                }
            }
        } else {
            currNum = self.sigFigCalculator.secondOperand.value;
            if(!([currNum isEqualToString:@"0"] && digit == 0)) {
                // Replace any single zero operands with their new value
                if([currNum isEqualToString:@"0"]) {
                    currNum = [NSString stringWithFormat:@"%ld", (long)digit];
                } else {
                    currNum = [currNum stringByAppendingString:[NSString stringWithFormat:@"%ld", (long)digit]];
                }
                self.sigFigCalculator.secondOperand.value = currNum;
                if(self.sigFigCalculator.secondOperand.containsDecimal) {
                    self.sigFigCalculator.secondOperand.precision++;
                }
                // If the operand is negative, negate it
                if(self.sigFigCalculator.secondOperand.isNegative) {
                    currNum = [@"-" stringByAppendingString:currNum];
                }
            }

        }
        self.display.text = currNum;
    }
}

- (IBAction)pressedClear:(UIButton *)sender
{
    // Force the user to clear out the calculator after recording the result
    for(UIButton *button in self.nonClearButtons) {
        button.alpha = 1.0;
        button.enabled = YES;
    }
    self.sigFigCalculator.firstOperand = nil;
    self.sigFigCalculator.secondOperand = nil;
    self.sigFigCalculator.currOperator = nil;
    
    self.display.text = @"0";
    self.operatorDisplayLabel.text = @"";
}

- (IBAction)pressedOperator:(UIButton *)sender
{
    // This is the case where the user initially presses an operator with the stock zero up
    // on the display
    if(self.sigFigCalculator.firstOperand == nil) {
        self.sigFigCalculator.firstOperand = [[Operand alloc]initWithValue:@"0"];
    }
    int newOperator = (int)sender.tag;
    if(newOperator == ADD) {
        self.operatorDisplayLabel.text = @"+";
    } else if(newOperator == SUBTRACT) {
        self.operatorDisplayLabel.text = @"-";
    } else if(newOperator == MULTIPLY) {
        self.operatorDisplayLabel.text = @"x";
    } else if(newOperator == DIVIDE) {
        self.operatorDisplayLabel.text = @"/";
    }
    self.sigFigCalculator.currOperator = [NSNumber numberWithInt:newOperator];
}

- (IBAction)pressedDecimal:(UIButton *)sender
{
    // Initialize Operand as decimal if this is it's first digit's value
    if(!self.sigFigCalculator.firstOperand) {
        self.sigFigCalculator.firstOperand = [[Operand alloc] initWithValue:@"0."];
        self.sigFigCalculator.firstOperand.containsDecimal = YES;
        self.display.text = self.sigFigCalculator.firstOperand.value;
    } else if (self.sigFigCalculator.currOperator && !self.sigFigCalculator.secondOperand) {
        self.sigFigCalculator.secondOperand = [[Operand alloc] initWithValue:@"0."];
        self.sigFigCalculator.secondOperand.containsDecimal = YES;
        self.display.text = self.sigFigCalculator.secondOperand.value;
    // Determine which operand we're looking at and add decimal if one not present
    } else {
        if(!self.sigFigCalculator.secondOperand) {
            if(!self.sigFigCalculator.firstOperand.containsDecimal) {
                self.sigFigCalculator.firstOperand.value = [self.sigFigCalculator.firstOperand.value stringByAppendingString:@"."];
                self.sigFigCalculator.firstOperand.containsDecimal = YES;
                self.display.text = self.sigFigCalculator.firstOperand.value;
                // Append back the lost negative sign
                if(self.sigFigCalculator.firstOperand.isNegative) {
                    self.display.text = [@"-" stringByAppendingString:self.display.text];
                }
            }
        } else {
            if(!self.sigFigCalculator.secondOperand.containsDecimal) {
                self.sigFigCalculator.secondOperand.value = [self.sigFigCalculator.secondOperand.value stringByAppendingString:@"."];
                self.sigFigCalculator.secondOperand.containsDecimal = YES;
                self.display.text = self.sigFigCalculator.secondOperand.value;
                // Append back the lost negative sign
                if(self.sigFigCalculator.secondOperand.isNegative) {
                    self.display.text = [@"-" stringByAppendingString:self.display.text];
                }
            }
        }
    }
}

- (IBAction)pressedEquals:(UIButton *)sender
{
    if(self.sigFigCalculator.currOperator) {
        // Have the SigFigCalculator calculate the result
        // Only utilize attributedStrings if the device supports them
        if(atLeastIOS6) {
            self.display.attributedText = [self.sigFigCalculator calculateResult];
        } else {
            self.display.text = [[self.sigFigCalculator calculateResult] string];
        }
        
    
        // Force the user to clear out the calculator after recording the result
        for(UIButton *button in self.nonClearButtons) {
            button.alpha = 0.3;
            button.enabled = NO;
        }
    
        self.operatorDisplayLabel.text = @"";
    }
}

- (IBAction)pressedNegate:(id)sender
{
    if(!([self.display.text floatValue] == 0)) {
        if(!self.sigFigCalculator.secondOperand) {
            if(!self.sigFigCalculator.firstOperand.isNegative) {
                self.display.text = [@"-" stringByAppendingString:self.sigFigCalculator.firstOperand.value];
            } else {
                self.display.text = [self.sigFigCalculator.firstOperand.value substringFromIndex:0];
            }
            self.sigFigCalculator.firstOperand.isNegative = !self.sigFigCalculator.firstOperand.isNegative;
        } else {
            if(!self.sigFigCalculator.secondOperand.isNegative) {
                self.display.text = [@"-" stringByAppendingString:self.sigFigCalculator.secondOperand.value];
            } else {
                self.display.text = [self.sigFigCalculator.secondOperand.value substringFromIndex:0];
            }
            self.sigFigCalculator.secondOperand.isNegative = !self.sigFigCalculator.secondOperand.isNegative;
        }
    }
}

- (IBAction)pressedBackspace:(UIButton *)sender
{
    // If the screen is simply a 0, a backspace can not be performed
    if(![self.display.text isEqual:@"0"]) {
        // We know that we're removing from the first operand
        if(!self.sigFigCalculator.secondOperand) {
            self.sigFigCalculator.firstOperand.value = [self.sigFigCalculator.firstOperand.value substringToIndex:(self.sigFigCalculator.firstOperand.value.length-1)];
            // Reset the value to zero if we're now left with a - or empty string
            if([self.sigFigCalculator.firstOperand.value isEqualToString:@""] ||
               [self.sigFigCalculator.firstOperand.value isEqualToString:@"-"]) {
                self.sigFigCalculator.firstOperand.isNegative = false;
                self.sigFigCalculator.firstOperand.value = @"0";
            }
            self.display.text = self.sigFigCalculator.firstOperand.value;
            // Update precision as well as whether the operand contains a decimal
            if([self.sigFigCalculator.firstOperand.value rangeOfString:@"."].location != NSNotFound) {
                self.sigFigCalculator.firstOperand.precision--;
                self.sigFigCalculator.firstOperand.containsDecimal = false;
            }
        } else {
            // We know that we're removing from the second operand
            self.sigFigCalculator.secondOperand.value = [self.sigFigCalculator.secondOperand.value substringToIndex:(self.sigFigCalculator.secondOperand.value.length-1)];
            // Reset the value to zero if we're now left with a - or empty string
            if([self.sigFigCalculator.secondOperand.value isEqualToString:@""] ||
                [self.sigFigCalculator.secondOperand.value isEqualToString:@"-"]) {
                self.sigFigCalculator.secondOperand.isNegative = false;
                self.sigFigCalculator.secondOperand.value = @"0";
            }
            self.display.text = self.sigFigCalculator.secondOperand.value;
            // Update precision as well as whether the operand contains a decimal
            if([self.sigFigCalculator.secondOperand.value rangeOfString:@"."].location != NSNotFound) {
                self.sigFigCalculator.secondOperand.precision--;
                self.sigFigCalculator.secondOperand.containsDecimal = false;
            }
        }
    }
}

@end
