//
//  ViewController.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 12/12/21.
//  Copyright (c) 2012 Kyle Gearhart. All rights reserved.
//
//  Calculates simple two-operand calculations and returns the result with
//  its significant figures underlined.

#import <UIKit/UIKit.h>
#import "Operand.h"
#import "SigFigCounter.h"
#import "SigFigConverter.h"

@interface SigFigCalculator : NSObject

// The two operands included in the current operation
@property (strong, nonatomic) Operand *firstOperand;
@property (strong, nonatomic) Operand *secondOperand;

// The operator to be applied
@property (strong, nonatomic) NSNumber *currOperator;

// Pointer to the SigFigCounter assisting with correct display of sigfigs
@property (strong, nonatomic) SigFigCounter *sigFigCounter;

// Carries out the operation with the given operands and operator
- (NSAttributedString *)calculateResult;

@end
