//
//  SigFigConverter.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/13.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//
//  A SigFigConverter will accept any positive, or negative integer or float and
//  return the number of significant figures contained within it. Implementing a
//  sort of strategy design pattern, the converter will accept input into its
//  generic countSigFigs method and then utilize the appropriate conversion
//  algorithm depending on the input type.

#import <Foundation/Foundation.h>
#import <math.h>
#import "SigFigCounter.h"

@interface SigFigConverter : NSObject

// Accepts the input integer or float and converts it into a new integer or
// float with the given number of significant figures
- (NSAttributedString *)convertNumSigFigs:(NSString *)number
                                       to:(NSString *)desiredNumSigFigs;

@end
