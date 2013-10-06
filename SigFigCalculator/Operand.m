//
//  Operand.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/02/08.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "Operand.h"

@implementation Operand
@synthesize value = _value;
@synthesize precision = _precision;
@synthesize numSigFigs = _numSigFigs;
@synthesize containsDecimal = _containsDecimal;
@synthesize isNegative = _isNegative;

// Designated initializer
- (id) init
{
    self = [super init];
    if(self) {
        self.value = [NSString stringWithFormat:@"%d", 0];
        self.precision = 0;
        self.numSigFigs = 0;
        self.containsDecimal = NO;
        self.isNegative = NO;
    }
    return self;
}

// Convenience initializer
- (id) initWithValue:(NSString *)digit
{
    self = [self init];
    if(self) {
        // Different initialization if it's a negative number
        if([digit characterAtIndex:0] == '-') {
            self.isNegative = YES;
            self.value = [digit substringFromIndex:1];
        } else {
            self.value = digit;
        }
        // Now that we just have the number, initialize the other fields
        for(int i = 0; i < self.value.length; ++i) {
            if(self.containsDecimal) {
                self.precision++;
            }
            if([self.value characterAtIndex:i] == '.') {
                self.containsDecimal = YES;
            }
        }
        SigFigCounter *counter = [[SigFigCounter alloc] init];
        self.numSigFigs = [counter countSigFigs:self.value];
    
    }
    return self;
}

// Convenience initializer
- (id)initWithOperand:(Operand *)other
{
    self = [self init];
    if(self) {
        self.value = other.value;
        self.isNegative = other.isNegative;
        self.containsDecimal = other.containsDecimal;
        self.numSigFigs = other.numSigFigs;
        self.precision = other.precision;
    }
    return self;
}

- (void)dealloc
{
    self.value = nil;
}


// Tests if the object this Operand is being compared with is an Operand
- (BOOL)isEqual:(id)other {
    if (other == self) { // self equality, compare address pointers
        return YES;
    }
    else if (!other || ![other isKindOfClass:[self class]]) {
        return NO;
    }
    return [self isEqualToOperand:other]; // call our isEqual method for Person objects
   
}

// Tests if two Operands are equal
- (BOOL)isEqualToOperand:(Operand *) other {
    if (self == other) { // test for self equality
        return YES;
    }
    return ((self.value == other.value) && (self.precision == other.precision) && (self.numSigFigs == other.numSigFigs) &&
            (self.containsDecimal == other.containsDecimal) && (self.isNegative == other.isNegative));
    
}

- (NSString *)description {
    NSString *containsDec;
    containsDec = (self.containsDecimal) ? @"YES" : @"NO";
    NSString *isNeg;
    isNeg = (self.isNegative) ? @"YES" : @"NO";
    return [NSString stringWithFormat:@"Value: %@ \nPrecision: %d \nNumSigFigs: %d \nContainsDecimal: %@ \nIsNegative: %@",
            self.value, self.precision, self.numSigFigs, containsDec, isNeg];
    
}

@end
