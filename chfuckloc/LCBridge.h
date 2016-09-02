//
//  LCBridge.h
//  CHFuckLocApp
//
//  Created by hya on 16/8/30.
//  Copyright © 2016年 ch4r0n. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LCBridge : NSObject

//得到app传输过来的加位置信息
+ (CLLocationCoordinate2D)getFakeLocation;
+ (BOOL)isOpenSwitch;

@end
