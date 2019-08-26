//
//  QuickstartCommon.m
//  Quickstart

#import "QuickstartCommon.h"

@implementation QuickstartCommon

+ (instancetype)shared {
    static QuickstartCommon *qCommon = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        qCommon = [[QuickstartCommon alloc] init];
        [[MyFiziqCommon shared] insert:qCommon];
    });
    return qCommon;
}

- (NSBundle *)sdkBundle {
    return [NSBundle mainBundle];
}

- (NSString *)sdkCssName {
    return @"myq-quickstart";
}

- (NSString *)sdkStringsTable {
    return @"Localizable";
}

@end
