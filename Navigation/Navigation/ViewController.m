//
//  ViewController.m
//  Navigation
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"

@interface ViewController ()<UINavigationControllerDelegate>

@end

@implementation ViewController
/*
//第一种方式隐藏导航栏。瑕疵是，在有tabbar存在时，点击tabbar 切换视图时，会看到navigationbar正在隐藏的动画
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
}

//第二种方式，隐藏导航栏。不存在第一种方式的瑕疵
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 判断要显示的控制器是否是自己
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];
    
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    FirstViewController * fVC = [[FirstViewController alloc] init];
    [self.navigationController pushViewController:fVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
