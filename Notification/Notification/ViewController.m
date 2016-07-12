//
//  ViewController.m
//  Notification
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"
#import "GYNotificationCenter.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[GYNotificationCenter defaultCenter] addObserver:self name:@"changeColor" block:^(NSNotification *notification) {
        self.view.backgroundColor = [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0];
    }];
}

- (void)dealloc{
    [[GYNotificationCenter defaultCenter] removerObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeColor:(UIButton *)sender {
    [[GYNotificationCenter defaultCenter] postNotificationName:@"changeColor" object:nil];
}
@end
