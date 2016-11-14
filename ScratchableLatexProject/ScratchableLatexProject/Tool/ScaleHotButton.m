//
//  ScaleHotButton.m
//  MCRM
//
//  Created by mac on 16/11/8.
//
//

#import "ScaleHotButton.h"

@implementation ScaleHotButton

//放大button 点击的热区
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //若原热区小于40x55，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(40.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(55.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
