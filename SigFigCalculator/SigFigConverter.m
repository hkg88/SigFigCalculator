#import "SigFigConverter.h"
#import "SigFigCounter.h"

@implementation SigFigConverter

- (NSAttributedString *)convertNumSigFigs:(NSString *)number
                                       to:(NSString *)desiredNumSigFigs
{
  NSString *result = number;
  
  // Matches integers which only contain zeros
  NSString *zeroIntRegex = @"(?:[-])?(?:[0])+";
  NSPredicate * zeroIntPredicate = [NSPredicate predicateWithFormat:
                                  @"SELF MATCHES %@", zeroIntRegex];
  
  // Matches any positive or negative integer value
  NSString *intRegex = @"(?:[-])?(?:[0-9])+";
  NSPredicate * intPredicate = [NSPredicate predicateWithFormat:
                              @"SELF MATCHES %@", intRegex];
  
  // Matches doubles which only contain zeros
  NSString *zeroFloatRegex = @"(?:[-])?(?:[0])*(?:[.])(?:[0])*";
  NSPredicate * zeroFloatPredicate = [NSPredicate predicateWithFormat:
                                    @"SELF MATCHES %@", zeroFloatRegex];
  
  // Matches any positive or negative float value
  NSString *floatRegex = @"(?:[-])?(?:[0-9])*(?:[.])(?:[0-9])*";
  NSPredicate * floatPredicate = [NSPredicate predicateWithFormat:
                                @"SELF MATCHES %@", floatRegex];
  
  // ** Input Error Checking **
  // Conversion to a negative number of significant zeros is impossible
  if([desiredNumSigFigs intValue] < 0) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(
              @"The Desired Number of Significant Figures can not be negative",
              @"Converter Negative Input")];
  // Conversion to a float number of significant figures is invalid
  } else if([desiredNumSigFigs rangeOfString:@"."].location != NSNotFound) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(
              @"The Desired Number of Significant Figures can not be a float",
              @"Converter Float Input")];
  // Abort conversion if the input value is anything else but an integer
  } else if(![intPredicate evaluateWithObject:desiredNumSigFigs]) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(
              @"The Desired Number of Significant Figures must be an integer",
              @"Converter Invalid DNOSF Input")];
  // Deny calculation to any number of significant figures which would put
  // significant strain on the device's hardware
  } else if([desiredNumSigFigs intValue] > 10000) {
        return [[NSAttributedString alloc] initWithString:NSLocalizedString(
              @"Please, be kind to your hardware",
              @"Converter Too Large Input")];
  // Conversions can only be performed on a properly formed integer or float
  } else if(!([intPredicate evaluateWithObject:result] ||
            [floatPredicate evaluateWithObject:result])) {
      return [[NSAttributedString alloc] initWithString:NSLocalizedString(
              @"Please enter a valid integer or float",
              @"Converter Invalid Input")];
  }
  
  
  
  // Count the number of significant figures in the input
  SigFigCounter *sigFigCounter = [[SigFigCounter alloc] init];
  int numSigFigsInNumber = [sigFigCounter countSigFigs:result];
  
  // Conversion to zero significant figures will always be zero
  if (desiredNumSigFigs == 0) {
    return [[NSAttributedString alloc] initWithString:@"0"];
  // Conversion of zero-only integers or floats can be streamlined
  } else if([zeroIntPredicate evaluateWithObject:number] == YES ||
          [zeroFloatPredicate evaluateWithObject:number] == YES) {
    return [self convertNumSigFigsInZeroString:number
                                            to:[desiredNumSigFigs intValue]];
  }
  
  // Convert if the number of desired significant figures isn't already present
  if(numSigFigsInNumber != [desiredNumSigFigs intValue]) {
    if([floatPredicate evaluateWithObject:result]) {
      result = [self convertNumSigFigsInFloat:number
                                         from:numSigFigsInNumber
                                           to:[desiredNumSigFigs intValue]];
    } else if([intPredicate evaluateWithObject:result]) {
      result = [self convertNumSigFigsInInt:number
                                       from:numSigFigsInNumber
                                         to:[desiredNumSigFigs intValue]];
    }
  }
  
    // Create an attributed version of the result to be returned
    NSMutableAttributedString *attributedResult =
    [[NSMutableAttributedString alloc] initWithString:result];
    int underlineBeginDelimiter;
    int underlineRangeSize = [desiredNumSigFigs intValue];
    
    // Enumerate through the result until the first significant figure is found
    int index = 0;
    bool decimalSeen = false;
    
    while(index < result.length && ([result characterAtIndex:index] == '0'
                                    || [result characterAtIndex:index] == '.'
                                    || [result characterAtIndex:index] == '-')) {
        if([result characterAtIndex:index] == '.') {
            decimalSeen = true;
        }
        index++;
    }
    // The beginning of the underline range is the index of the first significant
    // figure
    underlineBeginDelimiter = index;
    
    // Ensure that any decimals surrounded by significant figures will be
    // underlined
    if(!decimalSeen && [result rangeOfString:@"."].location != NSNotFound){
        underlineRangeSize++;
    }
    // Underline the appropriate indices in the resulting NSAttributedString
    [attributedResult addAttribute:NSUnderlineStyleAttributeName
                             value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                             range:NSMakeRange(underlineBeginDelimiter, underlineRangeSize)];
    
    return [[NSAttributedString alloc] initWithAttributedString:attributedResult];
}


- (NSAttributedString *)convertNumSigFigsInZeroString:(NSString *)number
                                                   to:(int)desiredNumSigFigs
{
  NSString *result = @"";
  // Build a string of 0s of length of the number of desired significant figures
  for(int i = 0; i < desiredNumSigFigs; i++) {
      result = [result stringByAppendingString:@"0"];
  }
  NSMutableAttributedString *underlinedString = [[NSMutableAttributedString alloc] initWithString:result];
  [underlinedString addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                           range:NSMakeRange(0, underlinedString.length)];
    
  return [[NSAttributedString alloc] initWithAttributedString:underlinedString];
}

- (NSString *)convertNumSigFigsInFloat:(NSString *)number
                                  from:(int)numSigFigs
                                    to:(int)desiredNumSigFigs
{
  NSString *result = number;
  // If more SigFigs are desired on a float, simply tack on extra 0s
  if(desiredNumSigFigs > numSigFigs) {
    for(int i = 0; i < (desiredNumSigFigs - numSigFigs); ++i) {
      result = [result stringByAppendingString:@"0"];
    }
  // Else round the number off at the appropriate place
  } else {
    // If the number begins without any leading zeroes, the position to round at
    // is the number of desired significant figures - the position of the decimal
    // Ex. 3.128 to 3 sigfigs --> 3 - 1 = 2 which will round the number to 3.13
    int positionOfDecimal = (int)[number rangeOfString:@"."].location;
    int indexToRoundTo = 0;
    // Round a negative float without any leading zeros
    if([number characterAtIndex:0] == '-' && [number characterAtIndex:1] != '0') {
      NSLog(@"1");
      indexToRoundTo = desiredNumSigFigs - positionOfDecimal + 1;
    // Round a positive float without leading zeros
    } else if([number characterAtIndex:0] != '0' && [number characterAtIndex:0] != '-') {
      indexToRoundTo = desiredNumSigFigs - positionOfDecimal;
    // Round a negative number with leading zeros
    } else if([number characterAtIndex:0] == '-') {
      indexToRoundTo = (int)(number.length - (numSigFigs - desiredNumSigFigs)) - (positionOfDecimal + 1);
    // Round a positive number with leading zeros
    } else {
      indexToRoundTo = (int)(number.length - (numSigFigs - desiredNumSigFigs)) - (positionOfDecimal + 1);
    }
    // -0.0125      length = 7 pos = 2
    // 0.0125       length = 6 pos = 1
    NSDecimalNumber *roundedNum = [NSDecimalNumber decimalNumberWithString:
                                   [NSString stringWithString:number]];
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler
                              decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                             scale:indexToRoundTo
                                                  raiseOnExactness:FALSE
                                                   raiseOnOverflow:TRUE
                                                  raiseOnUnderflow:TRUE
                                               raiseOnDivideByZero:TRUE];
    result = [[roundedNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
    // If rounding down caused a loss of the decimal and digits, add them back
    // Ex. 3.00003123 rounding to two SigFigs will become 3, in which case we
    // have to add the decimal and zeros
    if([result rangeOfString:@"."].location == NSNotFound &&
       [result length] < desiredNumSigFigs)  {
      result = [result stringByAppendingString:@"."];
    }
    // Replace any lost zeros which were rounded off
    if([result rangeOfString:@"."].location != NSNotFound &&
              [result length] - 1 < desiredNumSigFigs) {
      while(([result length] - 1) < desiredNumSigFigs) {
        result = [result stringByAppendingString:@"0"];
      }
    }
  }
  return result;
}

- (NSString *)convertNumSigFigsInInt:(NSString *)number
                                from:(int)numSigFigs
                                  to:(int)desiredNumSigFigs
{
  NSString *result = number;
  // More SigFigs are desired, simply tack on extra 0s after a decimal point
  if(desiredNumSigFigs > numSigFigs) {
    result = [result stringByAppendingString:@"."];
    for(int i = 0; i < (desiredNumSigFigs - numSigFigs); ++i) {
        result = [result stringByAppendingString:@"0"];
    }
  // Round the number off at the appropriate place
  } else {
    NSDecimalNumber *roundedNum = [NSDecimalNumber decimalNumberWithString:[NSString stringWithString:number]];
    // The position to round at is the number of desired sigfigs - the length
    // of the int
    // Ex. 38928 to 2 sigfigs --> 2 - 5 = -3 which will round the number to 39000
    int indexToRoundTo = (int)(desiredNumSigFigs - [number length]);
    // Negative numbers should be rounded one extra digit to the right
    if ([number characterAtIndex:0] == '-') {
      indexToRoundTo++;
    }
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler
                decimalNumberHandlerWithRoundingMode:NSRoundPlain
                                                scale:indexToRoundTo
                                     raiseOnExactness:FALSE
                                      raiseOnOverflow:TRUE
                                     raiseOnUnderflow:TRUE
                                  raiseOnDivideByZero:TRUE];
    result = [[roundedNum decimalNumberByRoundingAccordingToBehavior:roundingBehavior] stringValue];
  }
  return result;
}

@end
