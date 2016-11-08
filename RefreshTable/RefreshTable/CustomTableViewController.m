//
//  CustomTableViewController.m
//  RefreshTable
//
//  Created by mac on 16/7/13.
//  Copyright © 2016年 zhangjunli. All rights reserved.
//

#import "CustomTableViewController.h"
#import "CRMPageNumberView.h"

@interface CustomTableViewController ()<CRMPageNumberViewDelegate>
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,strong) NSNumber* beginY;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int totalPageNumber;
@property (nonatomic,assign) int currentPageNumber;
@property (nonatomic,strong) CRMPageNumberView * pageView;
@property (nonatomic,assign) CGFloat originY;

@end

@implementation CustomTableViewController

- (NSMutableArray *)dataArr {

    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;

    //刚开始必须先有数据，否则，table一直没有数据
    [self.dataArr addObject:@(1)];
    //用系统自带下拉刷新
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"上拉刷新"];
    [self.refreshControl addTarget:self action:@selector(refreshAction) forControlEvents:UIControlEventValueChanged];

    self.totalPageNumber = arc4random() % 20 + 1;// 模拟的 最大页数。
    NSLog(@"self.totalPageNumber  = %d",self.totalPageNumber );

    [self.tableView setContentOffset:CGPointZero];
    self.tableView.rowHeight = 100;

    //注册程序进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector (willEnterForeground:) name: UIApplicationDidBecomeActiveNotification object:nil];
}

- (CRMPageNumberView *)pageView {
    if (!_pageView) {

        CGFloat margin = 14.5;
        CGFloat width = 45.0;
        CGFloat originX = [UIScreen mainScreen].bounds.size.width - width - margin;
        self.originY = [UIScreen mainScreen].bounds.size.height - width - margin;
        _pageView = [[CRMPageNumberView alloc] initWithFrame:CGRectMake(originX, self.originY, width, width)];
        _pageView.pageDelegate = self;
        self.pageView.totalPageNumber = self.totalPageNumber;
    }
    return _pageView;
}

- (void)setupPageViewWithPageNumber:(int)number {
    // 添加页码
    [self.view addSubview:self.pageView];
    [self.view bringSubviewToFront:self.pageView];
    self.pageView.isTopImageHidden = YES;
    self.pageView.currentPageNumber = number + 1;//table 表是从0开始。故加 1
}

#pragma mark 下拉刷新事件
- (void)refreshAction{
    [self performSelector:@selector(refreshDelayAction) withObject:nil afterDelay:2.0];
}

- (void)refreshDelayAction {

    self.currentPageNumber = 1;
    self.dataArr = [self forgeDataWhenPullingToRefresh];
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

//伪造 下拉刷新 数据
- (NSMutableArray *)forgeDataWhenPullingToRefresh {

    NSMutableArray * dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [dataArray addObject:@(i)];
    }
    return dataArray;
}

#pragma mark 上拉加载事件

- (void)loadAction {
    [self performSelector:@selector(loadDelayAction) withObject:nil afterDelay:2.0];
}

- (void)loadDelayAction {

    self.currentPageNumber++;
    NSMutableArray * dataArray = [self forgeDataWhenPullingToLoad];
    [self.dataArr addObjectsFromArray:dataArray];
    [self.tableView reloadData];

    self.isLoading = NO;

    if (self.currentPageNumber == self.totalPageNumber) {

        NSLog(@"暂无更多内容");
        self.isLoading = YES;
    }
}

- (NSMutableArray *)forgeDataWhenPullingToLoad {

    static int data = 10;
    NSMutableArray * dataArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
        [dataArray addObject:@(data)];
        data++;
    }
    return dataArray;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //修改页码为向上的箭头
    self.pageView.isTopImageHidden = NO;
}

#pragma mark - UIScrollViewDelegate

//观察到，第一次加载时，contentOffset位移自动向下移动了一段，显示出了“上拉刷新”文字。写下面两个方法，是避免出现时，位移下移
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.beginY = [NSNumber numberWithFloat:scrollView.contentOffset.y];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!self.beginY) {
        [scrollView setContentOffset:CGPointZero];
    }

    //模拟 上拉加载
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height && scrollView.contentOffset.y > 0) {
        if (!self.isLoading && self.currentPageNumber != 0) {

            self.isLoading = YES;
            [self loadAction];
        }
    }

    //因为 是UITableViewController，故需要不断移动 pageView 的位置
    CGRect tempRect = self.pageView.frame;
    tempRect.origin.y = self.originY + scrollView.contentOffset.y;
    self.pageView.frame = tempRect;

    NSArray *visibleArray = [self.tableView visibleCells];
    UITableViewCell *cell = visibleArray.lastObject;
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    //在第一页，不显示。第二页以后（包括第二页），显示页码。第一页 10条数据
    if (indexPath.row > 9) {
        [self setupPageViewWithPageNumber:(int)(indexPath.row/10)];
    }else {
        [self.pageView removeFromSuperview];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageView.isTopImageHidden = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (!scrollView.dragging && !scrollView.decelerating) {
        self.pageView.isTopImageHidden = NO;
    }
}

#pragma mark 通知绑定方法

- (void)willEnterForeground:(NSNotification *)notification {

    self.pageView.isTopImageHidden = NO;
}

#pragma mark CRMPageNumberViewDelegate

- (void)didTriggerEventOfBackingToTop {

    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

@end
