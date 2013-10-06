//
//  SigFigCounter.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/03/09.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SigFigCounter : NSObject

- (int)countSigFigs:(NSString *)number;

- (int)countZeroIntSigFigs:(NSString *)number;
- (int)countZeroFloatSigFigs:(NSString *)number;

- (int)countFloatSigFigs:(NSString *)number;
- (int)countIntSigFigs:(NSString *)number;

@end
