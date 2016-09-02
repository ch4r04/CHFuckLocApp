//
//  CHButton.m
//  CHFuckLocApp
//
//  Created by hya on 16/9/1.
//  Copyright © 2016年 ch4r0n. All rights reserved.
//

#import "CHButton.h"
#define DEGREES_RADIANS(x) x*M_PI/180

@implementation CHButton{
    CGFloat angle;
}

- (void)startTransformWithDuration:(CGFloat)timer{
    [UIView animateWithDuration:timer
                          delay:0.0f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^
     {
         self.transform = CGAffineTransformRotate(self.transform, DEGREES_RADIANS(180));;
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:timer - 0.1 animations:^{
             self.transform = CGAffineTransformRotate(self.transform, DEGREES_RADIANS(180));
         } completion:^(BOOL finished) {
             
             [UIView animateWithDuration:timer - 0.2
                                   delay:0.0f
                                 options:UIViewAnimationOptionCurveLinear
                              animations:^
              {
                  self.transform = CGAffineTransformRotate(self.transform, DEGREES_RADIANS(180));
              }
                              completion:^(BOOL finished)
              {
                  [UIView animateWithDuration:timer - 0.3 animations:^{
                      self.transform = CGAffineTransformRotate(self.transform, DEGREES_RADIANS(180));
                  }];
                  
              }];
 
         }];
         
     }];
}

@end
