//
//  LocModel.m
//  CHFuckLocApp
//
//  Created by hya on 16/8/29.
//  Copyright © 2016年 ch4r0n. All rights reserved.
//

#import "LocModel.h"
#import <CoreLocation/CoreLocation.h>

@implementation LocModel

+ (void)writeToPlist:(NSDictionary *)dict{
    NSString *path = @"/var/mobile/Library/Preferences";
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSString *fileName = [path stringByAppendingPathComponent:@"CHLocation.plist"];
        [dict writeToFile:fileName atomically:YES];
    }else{
        NSLog(@"file ERROR");
    }

}

+ (NSDictionary *)getDicFromPlist{
    NSString *path = @"/var/mobile/Library/Preferences";
    NSString *fileName = [path stringByAppendingPathComponent:@"CHLocation.plist"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
        return dic;
    }else{
        NSLog(@"file ERROR");
        return [NSDictionary dictionary];
    }
    
 

}

@end
