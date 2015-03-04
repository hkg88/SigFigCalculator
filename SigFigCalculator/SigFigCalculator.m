#import "SigFigCalculator.h"

@implementation SigFigCalculator

#define ADDITION 1
#define SUBTRACTION 2
#define MULTIPLICATION 3
#define DIVISION 4

#pragma mark Unique SigFigCalculator Class Methods

- (NSAttributedString *) calculateResult
{
  // If an operator is specified, carry it out on the operands
  NSDecimalNumber *decimalNumResult;
  NSString *stringResult;
  NSAttributedString *attributedStringResult;

  SigFigCounter *sigFigCounter = [[SigFigCounter alloc] init];
  SigFigConverter *sigFigConverter = [[SigFigConverter alloc] init];
    
  // In the case that only one operand has been entered, duplicate it as the second
  if(!self.secondOperand) {
    self.secondOperand = [[Operand alloc] initWithOperand:self.firstOperand];
  }
    
  // Must obtain the number of SigFigs in both numbers
  self.firstOperand.numSigFigs = [sigFigCounter countSigFigs:self.firstOperand.value];
  self.secondOperand.numSigFigs = [sigFigCounter countSigFigs:self.secondOperand.value];
    
  // Get, and negate, operand values if necessary
  NSDecimalNumber *firstValue = [NSDecimalNumber decimalNumberWithString:self.firstOperand.value];
  if(self.firstOperand.isNegative) {
    firstValue = [firstValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
  }
  NSDecimalNumber *secondValue = [NSDecimalNumber decimalNumberWithString:self.secondOperand.value];
  if(self.secondOperand.isNegative) {
    secondValue = [secondValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"-1"]];
  }
    
  // Carry out the designated operation
  int currOp = [self.currOperator intValue];
  if(currOp == ADDITION || currOp == SUBTRACTION) {
    int precisionOfFirstNum = self.firstOperand.precision;
    int precisionOfSecondNum = self.secondOperand.precision;
    int minPrecision = (precisionOfFirstNum <= precisionOfSecondNum) ? precisionOfFirstNum : precisionOfSecondNum;
    if(currOp == ADDITION) {
      decimalNumResult = [firstValue decimalNumberByAdding:secondValue];
    } else if(currOp == SUBTRACTION) {
      decimalNumResult = [firstValue decimalNumberBySubtracting:secondValue];
    }
    // As per significant figure rules, round the result to the minimum precision
    int indexToRoundTo = minPrecision;
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler
                              decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                             scale:indexToRoundTo
                                                  raiseOnExactness:FALSE
                                                   raiseOnOverflow:TRUE
                                                  raiseOnUnderflow:TRUE
                                               raiseOnDivideByZero:TRUE];
    stringResult = [[decimalNumResult decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
    attributedStringResult = [[NSAttributedString alloc] initWithString:stringResult];
  } else if(currOp == MULTIPLICATION || currOp == DIVISION) {
    if(currOp == MULTIPLICATION) {
      decimalNumResult = [firstValue decimalNumberByMultiplyingBy:secondValue];
    } else if(currOp == DIVISION) {
      // Handle division by zero
      if([secondValue isEqualToNumber:[[NSNumber alloc] initWithInt:0]]) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Infinity", @"Calculator Infinity")];
        // Handle the case where it's zero divided by something
        } else if ([firstValue isEqualToNumber:[[NSNumber alloc] initWithInt:0]]) {
          decimalNumResult = [[NSDecimalNumber alloc] initWithString:@"0"];
        } else {
          decimalNumResult = [firstValue decimalNumberByDividingBy:secondValue];
        }
    }
    stringResult = [decimalNumResult stringValue];
        
    // Obtain the correct result by converting the result's number of SigFigs to the minimum
    // of the two operands
    int minNumSigFigs;
    minNumSigFigs = (self.firstOperand.numSigFigs <= self.secondOperand.numSigFigs) ?
                     self.firstOperand.numSigFigs : self.secondOperand.numSigFigs;
    attributedStringResult = [sigFigConverter convertNumSigFigs:stringResult
                                                             to:[NSString stringWithFormat:@"%d", minNumSigFigs]];
  }
    self.firstOperand = nil;
    self.secondOperand = nil;

    return attributedStringResult;
}

// Prints out the current state of the SigFigCalculator
- (NSString *)description
{
    return [NSString stringWithFormat:@"\n------------\nFirstOperand : %@\n--------------\nSecondOperand : %@\n---------------\n CurrOp : %@\n", self.firstOperand, self.secondOperand, [self.currOperator stringValue]];
}


@end
