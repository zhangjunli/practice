//
//  ViewController.m
//  四舍五入
//
//  Created by mac on 16/8/27.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //数字格式化后，去掉小数点末尾的0
    NSString * dataString = NStringOfFloat(1000000000000);
    dataString = [self removeZeroOfDataEnd:dataString];
}

//数字 格式化
NSString* NStringOfFloat(float fValue)
{
    if (fValue > 10000 * 10000)
    {
        return [NSString stringWithFormat:@"%.2f", fValue / (10000.0 * 10000.0)];
    }
    else if (fValue > 10000)
    {
        return [NSString stringWithFormat:@"%.2f", fValue / (10000.0)];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2f", fValue];
    }
}

//移除数据末位的0   //迭代算法
- (NSString *)removeZeroOfDataEnd:(NSString *)data {
    if ([data containsString:@"."]) {
        if ([data hasSuffix:@"0"] || [data hasSuffix:@"."]) {
            data = [data substringToIndex:(data.length - 1)];
            data = [self removeZeroOfDataEnd:data];
        }
    }
    return data;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
