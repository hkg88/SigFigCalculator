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

@end
