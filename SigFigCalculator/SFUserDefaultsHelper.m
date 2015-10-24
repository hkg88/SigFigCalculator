#import "SFUserDefaultsHelper.h"

@implementation SFUserDefaultsHelper

+ (instancetype)sharedManager {
    static SFUserDefaultsHelper *sharedDefaultsManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaultsManager = [[self alloc] init];
    });
    return sharedDefaultsManager;
}

- (BOOL)getBooleanForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

- (void)setBoolean:(BOOL)boolean forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:boolean forKey:key];
    [userDefaults synchronize];
}

- (void)removeObjectForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

@end
