//
//  CustomTableViewController.m
//  RefreshTable
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "CustomTableViewController.h"

@interface CustomTableViewController ()
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSNumber* beginY;

@end

@implementation CustomTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    self.dataArr = [[NSMutableArray alloc] initWithObjects:@1,@2,@3,@4,@5, nil];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"上拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];
    [self.tableView setContentOffset:CGPointZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshAction{
    self.dataArr = [[NSMutableArray alloc] initWithObjects:@0,@9,@7,@8,@4, nil];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.dataArr[indexPath.row]];
    
    return cell;
}

//观察到，第一次加载时，contentOffset位移自动向下移动了一段，显示出了“上拉刷新”文字。写下面两个方法，是避免出现时，位移下移
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.beginY = [NSNumber numberWithFloat:scrollView.contentOffset.y];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.beginY) {
        [scrollView setContentOffset:CGPointZero];
    }
}

@end
