//
//  ProgressView.m
//  progress
//
//  Created by mac on 16/9/8.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "HTProgressView.h"

@interface HTProgressView (){
    UIView * trackView;
    UIView * progressView;
}

@end

@implementation HTProgressView

- (void)awakeFromNib{
    [super awakeFromNib];

    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    trackView = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width, 0, 0, self.bounds.size.height)];
    [self addSubview:trackView];
    
    progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, self.bounds.size.height)];
    [self addSubview:progressView];
    
    self.backgroundColor = [UIColor grayColor];
    self.progressColor = [UIColor blueColor];
    self.trackColor = [UIColor orangeColor];
    self.duration = 1.0;
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self awakeFromNib];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setTrackColor:(UIColor *)trackColor{
    
    _trackColor = trackColor;
    trackView.backgroundColor = _trackColor;
}

- (void)setProgressColor:(UIColor *)progressColor{
    
    _progressColor = progressColor;
    progressView.backgroundColor = _progressColor;
}

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
    
    if (_progress > 1) {
        _progress = 1;
    }
    
    if (_progress < 0) {
        _progress = 0;
    }
    
    CGRect tempProgressR = progressView.frame;
    tempProgressR.size.width = self.bounds.size.width * _progress;
    progressView.frame = tempProgressR;
    
    CGRect tempTrackR = trackView.frame;
    tempTrackR.origin.x = self.bounds.size.width *  _progress;
    tempTrackR.size.width = self.bounds.size.width * (1 - _progress);
    trackView.frame = tempTrackR;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    NSTimeInterval duration = animated ? self.duration : 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.progress = progress;
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
