//
//  SigFigConverter.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/13.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <math.h>
#import "SigFigCounter.h"

@interface SigFigConverter : NSObject

// Accepts the initial call, does some input checking, and then passes the buck to the appropriate helper method
- (NSAttributedString *)convertNumSigFigs:(NSString *)number :(NSString *)desiredNumSigFigs;

// Helper methods which handle conversion of the different possible types of numbers
- (NSAttributedString *)convertZeroStringSigFigs:(NSString *)number :(int)desiredNumSigFigs;
- (NSString *)convertFloatNumSigFigs:(NSString *)number :(int)numSigFigs :(int)desiredNumSigFigs;
- (NSString *)convertIntNumSigFigs:(NSString *)number :(int)numSigFigs :(int)desiredNumSigFigs;

@end
