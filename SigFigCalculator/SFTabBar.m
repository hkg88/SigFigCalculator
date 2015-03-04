#import "SFTabBar.h"

@interface SFTabBar()
@property (nonatomic, copy) NSArray *items;
@end

@implementation SFTabBar

- (instancetype) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        ((UITabBarItem *)self.items[0]).title = NSLocalizedString(@"Calculator", @"Calculator");
        ((UITabBarItem *)self.items[1]).title = NSLocalizedString(@"Counter", @"Counter");
        ((UITabBarItem *)self.items[2]).title = NSLocalizedString(@"Converter", @"Converter");
        ((UITabBarItem *)self.items[3]).title = NSLocalizedString(@"Rules", @"Rules");
        ((UITabBarItem *)self.items[4]).title = NSLocalizedString(@"Settings", @"Settings");
    }
    return self;
}

@end
