//
//  LocModel.h
//  CHFuckLocApp
//
//  Created by hya on 16/8/29.
//  Copyright © 2016年 ch4r0n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocModel : NSObject

+ (void)writeToPlist:(NSDictionary *)dict;
+ (NSDictionary *)getDicFromPlist;
@end
