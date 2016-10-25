//
//  ViewController.m
//  progress
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"
#import "HTProgressView.h"


@interface ViewController ()
{
    //纯代码对象
    HTProgressView * mapProgress;
}

@property (weak, nonatomic) IBOutlet HTProgressView *progress;//xib控件对象
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressLeftMargin;//xib控件对象要用到的

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /*****  xib控件对象的调用  ******/
    self.progress.bounds = CGRectMake(0, 0, ([UIScreen mainScreen].bounds.size.width - (self.progressLeftMargin.constant * 2)), 4);
    [self.progress setProgress:0.3 animated:YES];
    
    /*****  纯代码对象的调用  ******/
    mapProgress = [[HTProgressView alloc] initWithFrame:CGRectMake(60, 200, 200, 4)];//此处也可使用init方法
    mapProgress.backgroundColor = [UIColor grayColor];
    mapProgress.progressColor = [UIColor blueColor];
    mapProgress.trackColor = [UIColor orangeColor];
    mapProgress.duration = 1.0;
    [self.view addSubview:mapProgress];
    [mapProgress setProgress:0.3 animated:YES];
    
    //模拟progress的动态改变
    [self performSelector:@selector(delayAction) withObject:nil afterDelay:3];
}

- (void)delayAction{
    [self.progress setProgress:0.6 animated:YES];
    [mapProgress setProgress:0.6 animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
