//
//  ViewController.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 12/12/21.
//  Copyright (c) 2012 Kyle Gearhart. All rights reserved.
//

#import "SigFigCalculator.h"

@implementation SigFigCalculator

@synthesize firstOperand = _firstOperand;
@synthesize secondOperand = _secondOperand;
@synthesize currOperator = _currOperator;
@synthesize sigFigCounter = _sigFigCounter;

enum{
    ADD = 1,
    SUBTRACT = 2,
    MULTIPLY = 3,
    DIVIDE = 4,
};

- (id)init
{
    self = [super init];
    if(self) {
        self.firstOperand = nil;
        self.secondOperand = nil;
        self.currOperator = nil;
        self.sigFigCounter = nil;
    }
    return self;
}

- (void)dealloc
{
    self.firstOperand = nil;
    self.secondOperand = nil;
    self.currOperator = nil;
    self.sigFigCounter = nil;
}

- (NSAttributedString *) calculateResult
{
    // If an operator is specified, carry it out on the operands
    NSDecimalNumber *decimalNumResult;
    NSString *result;
    NSAttributedString *attributedStringResult;

    SigFigCounter *sigFigCounter = [[SigFigCounter alloc] init];
    SigFigConverter *sigFigConverter = [[SigFigConverter alloc] init];
    
    // At this point, if a second operand has not been entered, it should be set to the value
    // of the first.
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
    if(currOp == ADD || currOp == SUBTRACT) {
        int precisionOfFirstNum = self.firstOperand.precision;
        int precisionOfSecondNum = self.secondOperand.precision;
        int minPrecision;
        minPrecision = (precisionOfFirstNum <= precisionOfSecondNum) ? precisionOfFirstNum : precisionOfSecondNum;
        if(currOp == ADD) {
            decimalNumResult = [firstValue decimalNumberByAdding:secondValue];
        } else if(currOp == SUBTRACT) {
            decimalNumResult = [firstValue decimalNumberBySubtracting:secondValue];
        }
        // The position to round at is the minprecision
        // Ex. 3.128 to 1 precision --> 1 which will round the number to 3.1
        int scale = minPrecision;
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE];
        result = [[decimalNumResult decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
        attributedStringResult = [[NSAttributedString alloc] initWithString:result];
    } else if(currOp == MULTIPLY || currOp == DIVIDE) {
        if(currOp == MULTIPLY) {
            decimalNumResult = [firstValue decimalNumberByMultiplyingBy:secondValue];
        } else if(currOp == DIVIDE) {
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
        result = [decimalNumResult stringValue];
        // Obtain the correct result by converting the result's number of SigFigs to the minimum
        // of the two operands
        int minNumSigFigs;
        minNumSigFigs = (self.firstOperand.numSigFigs <= self.secondOperand.numSigFigs) ? self.firstOperand.numSigFigs : self.secondOperand.numSigFigs;
        if(result < 0) {
            attributedStringResult = [sigFigConverter convertNumSigFigs:[result substringFromIndex:0]   :[NSString stringWithFormat:@"%d", minNumSigFigs]]
            ;
        } else {
            attributedStringResult = [sigFigConverter convertNumSigFigs:result :[NSString stringWithFormat:@"%d", minNumSigFigs]];
        }
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
