//
//  MyAnnotation.m
//  CHFuckLocApp
//
//  Created by hya on 16/8/31.
//  Copyright © 2016年 ch4r0n. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
-(id)initWithCoordinates:(CLLocationCoordinate2D)paramCoordinates title:(NSString *)paramTitle
                subTitle:(NSString *)paramSubitle
{
    self = [super init];
    if(self != nil)
    {
        _coordinate = paramCoordinates;
        _title = paramTitle;
        _subtitle = paramSubitle;
    }
    return self;
}

@end
