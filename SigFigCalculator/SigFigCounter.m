//
//  SigFigCounter.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "SigFigCounter.h"

@implementation SigFigCounter

- (id)init
{
    self = [super init];
    if(self) {
    }
    return self;
}

- (void)dealloc
{
}

- (int)countSigFigs:(NSString *)number {
    // A simple zero int regex
    NSString *zeroIntRegex = @"(?:[-])?(?:[0])+";
    NSPredicate * zeroIntPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", zeroIntRegex];
    
    // A zero float regex
    NSString *zeroFloatRegex = @"(?:[-])?(?:[0])*(?:[.])(?:[0])*";
    NSPredicate * zeroFloatPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", zeroFloatRegex];
    
    // A float regex
    NSString *floatRegex = @"(?:[-])?(?:[0-9])*(?:[.])(?:[0-9])*";
    NSPredicate * floatPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", floatRegex];
    
    // An integer regex
    NSString *intRegex = @"(?:[-])?(?:[0-9])+";
    NSPredicate * intPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", intRegex];

    // Depending on the type of number, send to the appropriate counter helper method
    if([zeroIntPredicate evaluateWithObject:number] == YES) {
        return [self countZeroIntSigFigs:number];
    } else if([zeroFloatPredicate evaluateWithObject:number] == YES) {
        return [self countZeroFloatSigFigs:number];
    } else if([floatPredicate evaluateWithObject:number] == YES) {
        return [self countFloatSigFigs:number];
    } else if([intPredicate evaluateWithObject:number] == YES) {
        return [self countIntSigFigs:number];
    } else {
        return -1; // If the entered number is invalid
    }
}

// Helper method which counts the number of significant figures in a int of only zeroes
- (int)countZeroIntSigFigs:(NSString *)number {
    // Initialize the number of SigFigs as the size of the number
    int numSigFigs = number.length;
    // Subtract out the potential negative sign
    if([number characterAtIndex:0] == '-') {
        numSigFigs--;
    }
    return numSigFigs;
}

// Helper method which counts the number of significant figures in a float of only zeroes
- (int)countZeroFloatSigFigs:(NSString *)number {
    // Initialize the number of SigFigs as the size of the number
    int numSigFigs = number.length;
    // Adjust for the possibility of a negative sign
    if([number characterAtIndex:0] == '-') {
        numSigFigs--;
    }
    // Remove the decimal as a SigFig
    numSigFigs--;
    return numSigFigs;
}

// Helper method which counts the number of significant figures in a float
- (int)countFloatSigFigs:(NSString *)number {
    // Initialize the number of SigFigs as the size of the number
    int numSigFigs = number.length;
    int index = 0;
    BOOL decimalSeen = FALSE;
    while(index < number.length && ([number characterAtIndex:index] == '0' || [number characterAtIndex:index] == '-' || [number characterAtIndex:index] == '.') ) {
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

// Helper method which counts the number of significant figures in an int
- (int)countIntSigFigs:(NSString *)number {
    // Initialize the number of SigFigs as the size of the number
    int numSigFigs = number.length;
    int index = 0;
    // The negative sign, or leading zeroes aren't significant
    while(index < number.length && ([number characterAtIndex:index] == '0' || [number characterAtIndex:index] == '-')) {
        numSigFigs--;
        index++;
    }
    return numSigFigs;
}

@end
