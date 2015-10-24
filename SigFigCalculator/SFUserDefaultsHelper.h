#import <Foundation/Foundation.h>

@interface SFUserDefaultsHelper : NSObject

+ (instancetype)sharedManager;

- (void)setBoolean:(BOOL)boolean forKey:(NSString *)key;
- (void)removeObjectForKey:(NSString *)key;
- (BOOL)getBooleanForKey:(NSString *)key;

@end
