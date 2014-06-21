//
//  SigFigCounter.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//
//  A SigFigCounter will accept any positive, or negative integer or float and
//  return the number of significant figures contained within it. Implementing a
//  sort of strategy design pattern, the counter will accept input into its
//  generic countSigFigs method and then utilize the appropriate counting
//  algorithm depending on the input type.

#import "SigFigCounter.h"

@implementation SigFigCounter

#define INVALID_INPUT -1

#pragma mark Overridden NSObject Methods

// ** Designated Initializer **
- (id)init
{
    self = [super init];
    if(self) {
    }
    return self;
}

#pragma mark Unique SigFigCounter Class Methods

// Employs the appropriate counting algorithm following the analysis of the
// input given, and then returns the number of significant figures contained
// within it.
// @param NSString : Positive or negative integer or float represented as an
// NSString
// @return int : Number of significant figures found within the given input
- (int)countSigFigs:(NSString *)number {
    // Matches integers which only contain zeros
    NSString *zeroIntRegex = @"(?:[-])?(?:[0])+";
    NSPredicate * zeroIntPredicate = [NSPredicate predicateWithFormat:
                                      @"SELF MATCHES %@", zeroIntRegex];
  
    // Matches any positive or negative integer value
    NSString *intRegex = @"(?:[-])?(?:[0-9])+";
    NSPredicate * intPredicate = [NSPredicate predicateWithFormat:
                                  @"SELF MATCHES %@", intRegex];
  
    // Matches doubles which only contain zeros
    NSString *zeroFloatRegex = @"(?:[-])?(?:[0])*(?:[.])(?:[0])*";
    NSPredicate * zeroFloatPredicate = [NSPredicate predicateWithFormat:
                                        @"SELF MATCHES %@", zeroFloatRegex];
    
    // Matches any positive or negative float value
    NSString *floatRegex = @"(?:[-])?(?:[0-9])*(?:[.])(?:[0-9])*";
    NSPredicate * floatPredicate = [NSPredicate predicateWithFormat:
                                    @"SELF MATCHES %@", floatRegex];
    
  

    // Depending on the regular expression which was matched, employ the correct
    // counting algorithm
    if([zeroIntPredicate evaluateWithObject:number] == YES) {
        return [self countSigFigsInZeroStringInt:number];
    } else if([zeroFloatPredicate evaluateWithObject:number] == YES) {
        return [self countSigFigsInZeroStringFloat:number];
    } else if([floatPredicate evaluateWithObject:number] == YES) {
        return [self countSigFigsInFloat:number];
    } else if([intPredicate evaluateWithObject:number] == YES) {
        return [self countSigFigsInInt:number];
    } else {
        return INVALID_INPUT; // If the entered number is invalid
    }
}

// Counts the number of significant figures contained within an integer of only
// zeros
// @param NSString : Integer containing some number of zeros
// @return int : Number of zeros, and thus number of significant figures
- (int)countSigFigsInZeroStringInt:(NSString *)number {
    // Initialize the number of SigFigs as the size of the number
    int numSigFigs = (int) number.length;
    // Subtract out the potential negative sign
    if([number characterAtIndex:0] == '-') {
        numSigFigs--;
    }
    return numSigFigs;
}

// Counts the number of significant figures contained within an integer
// @param NSString : Integer containing some number of significant figures
// @return int : Number of significant figures
- (int)countSigFigsInInt:(NSString *)number {
  // Initialize the number of SigFigs as the size of the number
  int numSigFigs = (int) number.length;
  int index = 0;
  // The negative sign, or leading zeroes aren't significant
  while(index < number.length && ([number characterAtIndex:index] == '0' ||
                                  [number characterAtIndex:index] == '-')) {
    numSigFigs--;
    index++;
  }
  return numSigFigs;
}

// Counts the number of significant figures contained within a float of only
// zeros
// @param NSString : Float containing some number of zeros and a decimal
// @return int : Number of zeros, and thus number of significant figures
- (int)countSigFigsInZeroStringFloat:(NSString *)number {
    // Initialize the number of SigFigs as the size of the number
    int numSigFigs = (int) number.length;
    // Reduce by one if a negation sign is present
    if([number characterAtIndex:0] == '-') {
        numSigFigs--;
    }
    // Subtract another one because a decimal point is always present
    numSigFigs--;
    return numSigFigs;
}

// Counts the number of significant figures contained within a float
// @param NSString : Float containing some number of significant figures
// @return int : Number of significant figures
- (int)countSigFigsInFloat:(NSString *)number {
    // Initialize the number of SigFigs as the size of the number
    int numSigFigs = (int) number.length;
    int index = 0;
    BOOL decimalSeen = FALSE;
    while(index < number.length && ([number characterAtIndex:index] == '0' ||
                                    [number characterAtIndex:index] == '-' ||
                                    [number characterAtIndex:index] == '.') ) {
        if([number characterAtIndex:index] == '.') {
            decimalSeen = TRUE;
        }
        // All leading zeros, dash, or decimal point are insignificant
        numSigFigs--;
        index++;
    }
    // If we still haven't seen the decimal, it must not be counted as a SigFig
    if(decimalSeen == FALSE) {
        numSigFigs--;
    }
    return numSigFigs;
}



@end
