@interface SFUserDefaultsHelper : NSObject

+ (instancetype)sharedManager;

- (void)setBoolean:(BOOL)boolean forKey:(NSString *)key;
- (BOOL)getBooleanForKey:(NSString *)key;

@end
