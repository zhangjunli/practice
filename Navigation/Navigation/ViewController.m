//
//  ViewController.m
//  Navigation
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"
#import "FirstViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
