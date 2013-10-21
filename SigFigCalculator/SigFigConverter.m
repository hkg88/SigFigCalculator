
//
//  SigFigConverter.m
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/13.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import "SigFigConverter.h"

#define atLeastIOS6 [[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0

@implementation SigFigConverter

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

// Converts the number into a new one with the desired number of SigFigs
// and returns that
- (NSAttributedString *)convertNumSigFigs:(NSString *)number :(NSString *)desiredNumSigFigs {
    
    // A simple zero int regex
    NSString *zeroIntRegex = @"(?:[-])?(?:[0]+)";
    NSPredicate * zeroIntPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", zeroIntRegex];
    
    // A zero float regex
    NSString *zeroFloatRegex = @"(?:[-])?(?:[0])*(?:[.])(?:[0])*";
    NSPredicate * zeroFloatPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", zeroFloatRegex];
    
    // A float regex
    NSString *floatRegex = @"(?:[0-9])*(?:[.])(?:[0-9])*";
    NSPredicate * floatPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", floatRegex];
    
    // An integer regex
    NSString *intRegex = @"(?:[0-9])*";
    NSPredicate * intPredicate = [NSPredicate predicateWithFormat: @"SELF MATCHES %@", intRegex];
    
    // If the user is asking for a negative number of SigFigs, print an error
    if([desiredNumSigFigs intValue] < 0) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"The Desired Number of Significant Figures can not be negative", @"Converter Negative Input")];
    // Likewise for requesting a float number of SigFigs
    } else if([desiredNumSigFigs rangeOfString:@"."].location != NSNotFound) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"The Desired Number of Significant Figures can not be a float", @"Converter Float Input")];
    } else if(![intPredicate evaluateWithObject:desiredNumSigFigs]) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"The Desired Number of Significant Figures must be an integer", @"Converter Invalid DNOSF Input")];
    } else if([desiredNumSigFigs intValue] > 10000) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please, be kind to your hardware", @"Converter Too Large Input")];
    }
    
    // If the number is just a string of zeroes, handle specially
    if([zeroIntPredicate evaluateWithObject:number] == YES || [zeroFloatPredicate evaluateWithObject:number] == YES) {
        return [self convertZeroStringSigFigs:number :[desiredNumSigFigs intValue]];
    }
   
    // Count the number of SigFigs to determine if conversion is necessary
    NSString *result = number;
    
    // Get rid of any leading zeroes and note if the number is negative
    int index = 0;
    int numLeadingZerosOrDash = 0;
    BOOL negativeNumber = NO;
    while(index < result.length && ([result characterAtIndex:index] == '0' || [result characterAtIndex:index] == '-')) {
        if([result characterAtIndex:index] == '-') {
            negativeNumber = YES;
        }
        numLeadingZerosOrDash++;
        index++;
    }
    result = [result substringFromIndex:numLeadingZerosOrDash];
    
    // Check for invalid input before counting SigFigs
    if(result.length == 0 || !([intPredicate evaluateWithObject:result] || [floatPredicate evaluateWithObject:result])) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Please enter a valid integer or float", @"Converter Invalid Input")];
    }
    
    // Add the 0 prior to the decimal back if deleted
    if([result characterAtIndex:0] == '.') {
        result = [@"0" stringByAppendingString:result];
    }
    
    SigFigCounter *sigFigCounter = [[SigFigCounter alloc] init];
    int numSigFigsInNumber = [sigFigCounter countSigFigs:result];
    // Only perform the conversion if the new number of SigFigs is different from
    // what is present
    if(numSigFigsInNumber != [desiredNumSigFigs intValue]) {
         if([floatPredicate evaluateWithObject:result]) {
            result = [self convertFloatNumSigFigs:result :numSigFigsInNumber :[desiredNumSigFigs intValue]];
        } else if([intPredicate evaluateWithObject:result]) {
            result = [self convertIntNumSigFigs:result :numSigFigsInNumber :[desiredNumSigFigs intValue]];
        }
    }
    
    // Add the negative sign back
    if(negativeNumber) {
        result = [@"-" stringByAppendingString:result];
    }
    
    NSMutableAttributedString *attributedResult = [[NSMutableAttributedString alloc] initWithString:result];
    //Only underline if the device supports it
    if(atLeastIOS6){
        // Get the range of the SigFigs so as to be able to underline properly
        int index = 0;
        bool decimalSeen = false;
        while(index < result.length && ([result characterAtIndex:index] == '0' || [result characterAtIndex:index] == '.' || [result characterAtIndex:index] == '-')) {
            if([result characterAtIndex:index] == '.') {
                decimalSeen = true;
            }
            index++;
        }
        int underlineBeginDelimiter = index;
        int underlineRange = [desiredNumSigFigs intValue];
        // Underline the surrounded decimal if necessary
        if(!decimalSeen && [result rangeOfString:@"."].location != NSNotFound){
            underlineRange++;
        }
        [attributedResult addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(underlineBeginDelimiter, underlineRange)];
    }
    return [[NSAttributedString alloc] initWithAttributedString:attributedResult];
}

// Helper method which converts the number of significant figures in an int of all 0s
- (NSAttributedString *)convertZeroStringSigFigs:(NSString *)number :(int)desiredNumSigFigs {
    NSString *result = @"";
    for(int i = 0; i < desiredNumSigFigs; i++) {
        result = [result stringByAppendingString:@"0"];
    }
    NSMutableAttributedString *underlinedString;
    // Only underline if the device supports it
    if(atLeastIOS6) {
        underlinedString = [[NSMutableAttributedString alloc] initWithString:result];
        [underlinedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, underlinedString.length)];
    } else {
        underlinedString = [[NSMutableAttributedString alloc] initWithString:result];
    }
    return [[NSAttributedString alloc] initWithAttributedString:underlinedString];
}

// Helper method which converts the number of significant figures in a float
- (NSString *)convertFloatNumSigFigs:(NSString *)number :(int)numSigFigs :(int)desiredNumSigFigs {
    NSString *result = number;
    // If more SigFigs are desired on a float, simply tack on extra 0s
    if(desiredNumSigFigs > numSigFigs) {
        for(int i = 0; i < (desiredNumSigFigs - numSigFigs); ++i) {
            result = [result stringByAppendingString:@"0"];
        }
    // If the desired number of SigFigs is the same as the length of the number, return the number
    }else if(desiredNumSigFigs == numSigFigs) {
        return number;
    // Else round the number off at the appropriate place
    } else {
        NSDecimalNumber *roundedNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithString:number]];
        // If the number begins without any leading zeroes, the position to round at is the number of desired
        // sigfigs - the position of the decimal Ex. 3.128 to 3 sigfigs --> 3 - 1 = 2 which will round the number to 3.13
        int scale = 0;
        if([number characterAtIndex:0] != '0' && [number characterAtIndex:0] != '.') {
            scale = desiredNumSigFigs - [number rangeOfString:@"."].location;
        } else {
            // Ex. 0.0000123 to 2 SigFigs = 9 - (3-2) = 8 --> 0.000012
            scale = number.length - (numSigFigs - desiredNumSigFigs) - 2;
        }
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE];
        result = [[roundedNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
        // If rounding down caused a loss of precision, add it back
        // Ex. 3.00003123 rounding to two SigFigs will become 3, in which case we have to add the decimal and zeroes
         // In this case, the decimal was removed after rounding and needs to be replaced to add zeros
        if([result rangeOfString:@"."].location == NSNotFound && [result length] < desiredNumSigFigs)  {
            result = [result stringByAppendingString:@"."];
            // Now, we must replace the lost zeros which were rounded off
            while(([result length] - 1) < desiredNumSigFigs) {
                result = [result stringByAppendingString:@"0"];
            }
        }else if([result rangeOfString:@"."].location != NSNotFound && [result length] - 1 < desiredNumSigFigs) {
            // Replace the lost zeros which were rounded off
            while(([result length] - 1) < desiredNumSigFigs) {
                result = [result stringByAppendingString:@"0"];
            }
        }
    }
    return result;
}

// Helper method which converts the number of significant figures in an int
- (NSString *)convertIntNumSigFigs:(NSString *)number :(int)numSigFigs :(int)desiredNumSigFigs {
    NSString *result = number;
    // If the desired number of SigFigs is 0, have the result be 0
    if(desiredNumSigFigs == 0) {
        result = @"0";
    // If the desired number of SigFigs is the same as the length of the number, return the number
    } else if (desiredNumSigFigs == number.length) {
        return number;
    // If more SigFigs are desired on an int, simply tack on extra 0s and possibly a decimal point
    } else if(desiredNumSigFigs > numSigFigs) {
        result = [result stringByAppendingString:@"."];
        for(int i = 0; i < (desiredNumSigFigs - numSigFigs); ++i) {
            result = [result stringByAppendingString:@"0"];
        }
    // Else round the number off at the appropriate place
    } else {
        NSDecimalNumber *roundedNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithString:number]];
        // The position to round at is the number of desired sigfigs - the length of the int
        // Ex. 38928 to 2 sigfigs --> 2 - 5 = -3 which will round the number to 39000
        int scale = desiredNumSigFigs - [number length];
        NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:scale raiseOnExactness:FALSE raiseOnOverflow:TRUE raiseOnUnderflow:TRUE raiseOnDivideByZero:TRUE];
        result = [[roundedNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
    }
    return result;
}

@end
