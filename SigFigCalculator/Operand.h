#import "SigFigCounter.h"

@interface Operand : NSObject

@property (copy, nonatomic) NSString *value;
@property (nonatomic) int precision;
@property (nonatomic) int numSigFigs;
@property (nonatomic) BOOL containsDecimal;
@property (nonatomic) BOOL isNegative;

- (id) initWithValue:(NSString *)digit;
- (id) initWithOperand:(Operand *)operand;

@end
