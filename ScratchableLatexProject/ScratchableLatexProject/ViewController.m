//
//  ViewController.m
//  ScratchableLatexProject
//
//  Created by mac on 16/11/14.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"
#import "ConfigView.h"

@interface ViewController ()<ConfigViewDelegate>
@property (nonatomic,strong) ConfigView * configView;

@end

@implementation ViewController

- (ConfigView *)configView {
    if (!_configView) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        _configView = [[ConfigView alloc] initWithFrame:CGRectMake(width, 0, width, height)];
        _configView.configViewDelegate = self;
    }
    return _configView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UILabel * label = [[UILabel alloc] init];
    label.frame = CGRectMake(80, 100, 250, 30);
    label.text = @"点击屏幕，出现config view";
    label.textColor = [UIColor orangeColor];
    [self.view addSubview:label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {

    [self.view addSubview:self.configView];
    [self.configView show];
}

#pragma mark ConfigViewDelegate

- (void)didConfirmEvent {}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
