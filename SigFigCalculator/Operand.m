#import "Operand.h"

@implementation Operand

- (id) init
{
    self = [super init];
    if(self) {
        self.value = [NSString stringWithFormat:@"%d", 0];
        self.containsDecimal = NO;
        self.isNegative = NO;
    }
    return self;
}

- (id)initWithOperand:(Operand *)operand
{
    self = [self init];
    if(self) {
        _value = operand.value;
        _isNegative = operand.isNegative;
        _containsDecimal = operand.containsDecimal;
        _numSigFigs = operand.numSigFigs;
        _precision = operand.precision;
    }
    return self;
}

- (instancetype) initWithValue:(NSString *)digit
{
    self = [self init];
    if(self) {
        // If the value is negative
        if([digit characterAtIndex:0] == '-') {
            // Shave off the negation sign from the value and indicate it as negative
            _value = [digit substringFromIndex:1];
            _isNegative = YES;
        } else {
            _value = digit;
        }
        
        // Calculate the operand's precision if applicable
        for(int i = 0; i < _value.length; ++i) {
            // If a decimal has been seen increment the operand's precision
            if(_containsDecimal) {
                _precision++;
            }
            // If a decimal was seen, record it
            if([_value characterAtIndex:i] == '.') {
                _containsDecimal = YES;
            }
        }
        
        // Count and store the number of significant figures in the operand
        SigFigCounter *counter = [[SigFigCounter alloc] init];
        _numSigFigs = [counter countSigFigs:self.value];
    }
    return self;
}

- (NSString *)description
{
  NSString *containsDecimal = (self.containsDecimal) ? @"YES" : @"NO";
  NSString *isNegative = (self.isNegative) ? @"YES" : @"NO";
  return [NSString stringWithFormat:@"Value: %@ \nPrecision: %d \nNumSigFigs:  "
          "%d\nContainsDecimal: %@ \nIsNegative: %@", self.value, self.precision,
          self.numSigFigs, containsDecimal, isNegative];
}

- (BOOL)isEqual:(id)other
{
  if (other == self) {
    return YES;
  } else if (!other || ![other isKindOfClass:[self class]]) {
    return NO;
  } else {
    Operand *otherOperand = (Operand*) other;
    return ((self.value == otherOperand.value)
            && (self.precision == otherOperand.precision)
            && (self.numSigFigs == otherOperand.numSigFigs)
            && (self.containsDecimal == otherOperand.containsDecimal)
            && (self.isNegative == otherOperand.isNegative));
  }
}

@end
