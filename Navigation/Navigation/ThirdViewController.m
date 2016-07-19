//
//  ThirdViewController.m
//  Navigation
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ThirdViewController.h"
#import "SecondViewController.h"
#import "NavViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    /*
    //方法一 正序查找
    NavViewController * navVC = (NavViewController *)self.navigationController;
    [navVC cleanLoginViewControllerWithAnimated:YES];
    
    //方法一 正序查找
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ThirdViewController class]]) {
            [controllers removeObject:vc];
        }
    }
    [self.navigationController setViewControllers:controllers animated:YES];
     */
    
    //方法二 倒序查找数组中的元素，可对元素进行删除
    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (int i = (controllers.count - 1); i > -1; i--) {
        UIViewController * vc = controllers[i];
        if ([vc isKindOfClass:[ThirdViewController class]]) {
            [controllers removeObject:vc];
        }
    }
    
    [self.navigationController setViewControllers:controllers animated:YES];
    
//    SecondViewController * sVC = [[SecondViewController alloc] init];
//    [self.navigationController pushViewController:sVC animated:YES];
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
