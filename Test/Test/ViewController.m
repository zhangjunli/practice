//
//  ViewController.m
//  Test
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController (){
    UIView * aView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    aView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self frameAdjustment];
    aView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:aView];
}

- (void)frameAdjustment{
    
    UINavigationBar *dummyBar = [[UINavigationBar alloc] init];
    CGFloat barHeight = [dummyBar sizeThatFits:CGSizeMake(100,100)].height;
    CGFloat offset = barHeight + statusBarAdjustment(aView);

    CGRect tempRect = aView.frame;
    tempRect.origin.y += offset;
    tempRect.size.height -= offset;
    aView.frame = tempRect;
}

static CGFloat statusBarAdjustment( UIView* view )
{
    CGFloat adjustment = 0.0f;
    UIApplication *app = [UIApplication sharedApplication];
    CGRect viewFrame = [view convertRect:view.bounds toView:[app keyWindow]];
    CGRect statusBarFrame = [app statusBarFrame];
    
    if ( CGRectIntersectsRect(viewFrame, statusBarFrame) )
        adjustment = fminf(statusBarFrame.size.width, statusBarFrame.size.height);
    
    return adjustment;
}

@end
