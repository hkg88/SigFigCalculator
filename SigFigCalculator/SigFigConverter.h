#import <Foundation/Foundation.h>
#import <math.h>
#import "SigFigCounter.h"

@interface SigFigConverter : NSObject

- (NSAttributedString *)convertNumSigFigs:(NSString *)number
                                       to:(NSString *)desiredNumSigFigs;

@end
