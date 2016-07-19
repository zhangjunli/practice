//
//  NavViewController.m
//  Navigation
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)cleanViewControllerWithCls:(Class)viewControllerCls animated:(BOOL)animated {
    BOOL isFound = NO;
    
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.viewControllers];
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:viewControllerCls]) {
            [controllers removeObject:vc];
            isFound = YES;
        }
    }
    if (isFound) {
        [self setViewControllers:controllers animated:animated];
    }
}

- (void)cleanLoginViewControllerWithAnimated:(BOOL)animated {
    Class loginCls = NSClassFromString(@"SecondViewController");
    
    UIViewController *topVC = self.topViewController;
    if ([topVC isKindOfClass:loginCls]) {
        [topVC.navigationController popViewControllerAnimated:animated];
        return;
    }
    [self cleanViewControllerWithCls:loginCls animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
