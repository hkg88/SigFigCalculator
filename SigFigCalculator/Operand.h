//
//  Operand.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/02/08.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//
//  Designed to encapsulate all the needed properties along with the
//  actual value of the operand itself. This comes in handy when the
//  application's converter, counter, etc., wants to know the number of
//  significant figures contained in an operand, etc.

#import "SigFigCounter.h"

@interface Operand : NSObject

// Integer or double value represented as a NSString
@property (copy, nonatomic) NSString *value;

// Number of digits after the operand's decimal
@property (nonatomic) int precision;

// Number of significant figures contained in the operand
@property (nonatomic) int numSigFigs;

// Indicates if the number is an integer or double
@property (nonatomic) BOOL containsDecimal;

// Quickly allows testing for negativity without inspecting the NSString value
@property (nonatomic) BOOL isNegative;

// Convenience initializers
- (id) initWithValue:(NSString *)digit;
- (id) initWithOperand:(Operand *)operand;

@end
