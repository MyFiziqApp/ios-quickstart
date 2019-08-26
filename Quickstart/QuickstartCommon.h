//
//  QuickstartCommon.h
//  Quickstart

#import <Foundation/Foundation.h>
#import <MyFiziqSDKCommon/MyFiziqCommon.h>

@interface QuickstartCommon : MyFiziqCommon <MyFiziqCommonProtocol>
// Singleton interface.
+ (instancetype _Nullable)shared;
@end
