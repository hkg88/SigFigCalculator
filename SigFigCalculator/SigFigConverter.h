@interface SigFigConverter : NSObject

- (NSAttributedString *)convertNumSigFigs:(NSString *)number
                                       to:(NSString *)desiredNumSigFigs;

@end
