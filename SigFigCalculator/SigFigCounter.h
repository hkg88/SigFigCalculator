//
//  SigFigCounter.h
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

#import <Foundation/Foundation.h>

@interface SigFigCounter : NSObject

// Generic method used to count the number of significant figures contained
// in any form of integer or float represented as an NSString
- (int)countSigFigs:(NSString *)number;

@end
