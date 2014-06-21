//
//  Operand.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/02/08.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//
//  Designed to encapsulate all the needed properties along with the
//  actual value of the operand itself. This comes in handy when the
//  application's converter, counter, etc., wants to know the number of
//  significant figures contained in an operand, etc.

#import "Operand.h"

@implementation Operand

#pragma mark Overridden NSObject Methods

// ** Designated Initializer **
// Initializes an operand with the integer value of 0
- (id) init {
    self = [super init];
    if(self) {
        self.value = [NSString stringWithFormat:@"%d", 0];
        self.containsDecimal = NO;
        self.isNegative = NO;
    }
    return self;
}

// Returns a description of this instance of Operand
// @return NSString : Contains the Operand's value and properties
- (NSString *)description {
  // Get NSString values for BOOL properties
  NSString *containsDecimal = (self.containsDecimal) ? @"YES" : @"NO";
  NSString *isNegative = (self.isNegative) ? @"YES" : @"NO";
  return [NSString stringWithFormat:@"Value: %@ \nPrecision: %d \nNumSigFigs:  "
          "%d\nContainsDecimal: %@ \nIsNegative: %@", self.value, self.precision,
          self.numSigFigs, containsDecimal, isNegative];
}

// Tests if two Operands have the same value and properties
// @param id : Other NSObject to be compared with
// @return BOOL : Whether or not the two Operands hold the same value and
// properties
- (BOOL)isEqual:(id)other {
  if (other == self) {
    return YES; // An object is equal to itself
  } else if (!other || ![other isKindOfClass:[self class]]) {
    return NO; // Objects of a different class or nil are not equal
  } else {
    // Compare the value and properties of the two Operand objects
    Operand *otherOperand = (Operand*) other;
    return ((self.value == otherOperand.value)
            && (self.precision == otherOperand.precision)
            && (self.numSigFigs == otherOperand.numSigFigs)
            && (self.containsDecimal == otherOperand.containsDecimal)
            && (self.isNegative == otherOperand.isNegative));
  }
}

#pragma mark Unique Operand Class Methods

// ** Convenience Initializer **
// Allows for quick initialization of an operand with a value
// @param NSString : Integer or double to be used as the operand's value
// @return Operand : Created Operand instance with the given value
- (instancetype) initWithValue:(NSString *)digit
{
  self = [self init];
  if(self) {
    // If the value is negative
    if([digit characterAtIndex:0] == '-') {
      // Shave off the negation sign from the value and indicate it as negative
      self.value = [digit substringFromIndex:1];
      self.isNegative = YES;
    } else {
      self.value = digit;
    }
    
    // Calculate the operand's precision if applicable
    for(int i = 0; i < self.value.length; ++i) {
      // If a decimal has been seen increment the operand's precision
      if(self.containsDecimal) {
        self.precision++;
      }
      // If a decimal was seen, record it
      if([self.value characterAtIndex:i] == '.') {
        self.containsDecimal = YES;
      }
    }
    
    // Count and store the number of significant figures in the operand
    SigFigCounter *counter = [[SigFigCounter alloc] init];
    self.numSigFigs = [counter countSigFigs:self.value];
  }
  return self;
}


// ** Convenience Initializer **
// Intitializes an operand to be a copy of a given Operand
// @param Operand : Serves as a prototype for the creation of a new Operand
// @return Operand : Created Operand instance with the given value
- (id)initWithOperand:(Operand *)operand
{
  self = [self init];
  if(self) {
    self.value = operand.value; // Copies the prototype's value
    self.isNegative = operand.isNegative;
    self.containsDecimal = operand.containsDecimal;
    self.numSigFigs = operand.numSigFigs;
    self.precision = operand.precision;
  }
  return self;
}

@end
