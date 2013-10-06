//
//  Operand.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 13/02/08.
//  Copyright (c) 2013 Kyle Gearhart. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SigFigCounter.h"

@interface Operand : NSObject

@property (strong, nonatomic) NSString *value;
@property (nonatomic) int precision;
@property (nonatomic) int numSigFigs;
@property (nonatomic) BOOL containsDecimal;
@property (nonatomic) BOOL isNegative;

- (id) initWithValue:(NSString *)digit;
- (id) initWithOperand:(Operand *)other;
- (NSString *)description;

@end
