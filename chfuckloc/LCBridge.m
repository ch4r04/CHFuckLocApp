//
//  LCBridge.m
//  CHFuckLocApp
//
//  Created by hya on 16/8/30.
//  Copyright © 2016年 ch4r0n. All rights reserved.
//

#import "LCBridge.h"

@implementation LCBridge

/**
 *   获取位置
 *
 *  @return coordinate2d
 */
+ (CLLocationCoordinate2D)getFakeLocation{
    NSString *path = @"/var/mobile/Library/Preferences";
    NSString *fileName = [path stringByAppendingPathComponent:@"CHLocation.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
    CLLocationCoordinate2D fakeLocation = CLLocationCoordinate2DMake([dic[@"latitude"] doubleValue], [dic[@"longitude"] doubleValue]);
    return fakeLocation;
}
/**
 *  判断是否需要勾住
 *
 *  @return bool
 */
+ (BOOL)isOpenSwitch{
    NSString *path = @"/var/mobile/Library/Preferences";
    NSString *fileName = [path stringByAppendingPathComponent:@"CHLocation.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
    return [dic[@"isOpen"] boolValue];
 
}
@end
