//
//  CustomBtn.m
//  ClickEvent
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "CustomBtn.h"

@implementation CustomBtn

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//重写系统方法 放大button 点击的热区
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
{
    CGRect bounds = self.bounds;
    //若原热区小于60x60，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(60.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(60.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);//以自身的中心点，向四周扩展可点击区域
    return CGRectContainsPoint(bounds, point);
}

@end
