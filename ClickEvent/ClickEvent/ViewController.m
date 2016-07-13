//
//  ViewController.m
//  ClickEvent
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"
#import "CustomBtn.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //第一种扩大点击区域的方式，可点击的控件在父控件外，依然能够响应点击事件
    CustomView * customView = [[CustomView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    customView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:customView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 0, 100, 40);
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(clickEvent) forControlEvents:UIControlEventTouchUpInside];
    [customView addSubview:btn];
    
    //第二种扩大点击区域的方式，通过扩大热区的方式
    CustomBtn * button = [CustomBtn buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor purpleColor];
    button.frame = CGRectMake(150, 200, 30, 30);
    [button addTarget:self action:@selector(clickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)clickEvent{
    NSLog(@"触发点击事件");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
