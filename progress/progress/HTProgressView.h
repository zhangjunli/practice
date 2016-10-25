//
//  ProgressView.h
//  progress
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTProgressView : UIView

@property (nonatomic,strong) UIColor * trackColor;
@property (nonatomic,strong) UIColor * progressColor;
@property (nonatomic,assign) CGFloat progress;
@property (nonatomic,assign) NSTimeInterval duration;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

@end
