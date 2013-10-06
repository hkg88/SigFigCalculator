//
//  ViewController.h
//  SigFigCalculator
//
//  Created by Kyle Gearhart on 12/12/21.
//  Copyright (c) 2012 Kyle Gearhart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Operand.h"
#import "SigFigCounter.h"
#import "SigFigConverter.h"

@interface SigFigCalculator : NSObject

@property (strong, nonatomic) Operand *firstOperand;
@property (strong, nonatomic) Operand *secondOperand;
@property (strong, nonatomic) NSNumber *currOperator;
@property (strong, nonatomic) SigFigCounter *sigFigCounter;

- (NSAttributedString *)calculateResult;
- (NSString *)description;

@end
