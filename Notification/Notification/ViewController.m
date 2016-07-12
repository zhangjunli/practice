//
//  ViewController.m
//  Notification
//
//  Created by mac on 16/7/12.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"
#import "GYNotificationCenter.h"

/**

 载录线程理解
 addObserver 在主线程中。postNotification 在分线程中调用。则addObserver绑定的方法，也将在分线程中执行。对于将在分线程中执行的UI操作，需要强制切换线程。如下：
     dispatch_async(dispatch_get_main_queue(), ^{
          NSLog(@"current thread = %@", [NSThread currentThread]);
    });
 iOS4，提供了带block的NSNotification,但移除时麻烦点，需要逐个删除注册的通知，未解决逐个删除的问题，第三方的
GYNotificationCenter诞生了。
*/


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
