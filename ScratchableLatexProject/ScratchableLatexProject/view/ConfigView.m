//
//  ConfigView.m
//  MCRM
//
//  Created by mac on 16/10/24.
//
//

#import "ConfigView.h"
#import "ConfigTableViewCell.h"
#import "UIColor+XXYExtension.h"

#define FIXED_HEIGHT         74.5
#define BUTTON_HEIGHT        30
#define BUTTON_BUTTON_MARGIN 12
#define BLACK_WIDTH          35
#define BTN_HEIGHT           55
#define FOLD_HEIGHT          @"foldHeight"
#define UNFOLD_HEIGHT        @"unfoldHeight"
#define STATUS               @"status"

@interface ConfigView ()<UITableViewDelegate,UITableViewDataSource,ConfigTableViewCellDelegate>

@property (nonatomic,strong) UITableView * configTable;
@property (nonatomic,strong) UIControl * bgControl;
@property (nonatomic,strong,readwrite) NSMutableArray * selectedItems;

@end

@implementation ConfigView

#pragma mark 数据

- (NSMutableArray *)testData {

    NSMutableArray * customerSource = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
    NSMutableArray * customerType = [NSMutableArray arrayWithObjects:@"4",@"5", nil];
    NSMutableArray * customerLevel = [NSMutableArray arrayWithObjects:@"6",@"7",@"8",@"9",@"10", nil];
    NSMutableArray * riskLevel = [NSMutableArray arrayWithObjects:@"11",@"12",@"13",@"14",@"15", nil];
    NSMutableArray * accountStatus = [NSMutableArray arrayWithObjects:@"16",@"17",@"18",@"19",@"20",@"21", nil];

    //NO：展开  YES: 折叠
    NSMutableDictionary * sourceDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:customerSource,@"第一个title",@"NO",STATUS, nil];
    sourceDic = [self addCellHeightToDictionary:sourceDic];
    NSMutableDictionary * typeDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:customerType,@"第二个title",@"NO",STATUS, nil];
    typeDic = [self addCellHeightToDictionary:typeDic];
    NSMutableDictionary * leveleDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:customerLevel,@"第三个title",@"NO",STATUS, nil];
    leveleDic = [self addCellHeightToDictionary:leveleDic];
    NSMutableDictionary * riskDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:riskLevel,@"第四个title",@"NO",STATUS, nil];
    riskDic = [self addCellHeightToDictionary:riskDic];
    NSMutableDictionary * statusDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:accountStatus,@"第五个title",@"NO",STATUS, nil];
    statusDic = [self addCellHeightToDictionary:statusDic];

    NSMutableArray * dataArr = [NSMutableArray array];
    [dataArr addObject:sourceDic];
    [dataArr addObject:typeDic];
    [dataArr addObject:leveleDic];
    [dataArr addObject:riskDic];
    [dataArr addObject:statusDic];

    return dataArr;
}

- (NSMutableDictionary *)addCellHeightToDictionary:(NSMutableDictionary *)dic {

    NSString * keyStr = dic.allKeys.firstObject;
    if ([keyStr isEqualToString:STATUS]) {
        keyStr = dic.allKeys.lastObject;
    }
    NSArray * array = [dic objectForKey:keyStr];
    int sourceRow = ((int)array.count -1) / 3;
    CGSize sourceSize = [keyStr sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0]}];
    CGFloat foldHeight = 16 + sourceSize.height + 38.5 + 30;
    CGFloat unfoldHeight = 16 + sourceSize.height + 38.5 + (sourceRow+1)*30 + sourceRow*12;
    [dic setObject:@(foldHeight) forKey:FOLD_HEIGHT];
    [dic setObject:@(unfoldHeight) forKey:UNFOLD_HEIGHT];

    return dic;
}

#pragma mark 初始化

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {
        //背景
        [self addSubview:self.bgControl];
        //table 数据源
        self.dataArray = [self testData];
        //添加table
        [self addSubview:self.configTable];

        //reset button
        CGFloat width = ([UIScreen mainScreen].bounds.size.width - BLACK_WIDTH)/2.0;
        UIButton * resetBtn = [self customButtonWithTitle:@"重置" titleColor:[UIColor blackColor] selector:@selector(buttonClick:) bgColor:[UIColor whiteColor] frame:CGRectMake(BLACK_WIDTH, ([UIScreen mainScreen].bounds.size.height - BTN_HEIGHT), width, BTN_HEIGHT)];
        //confirm button
        UIButton * confirmBtn = [self customButtonWithTitle:@"确定" titleColor:[UIColor whiteColor] selector:@selector(buttonClick:) bgColor:[UIColor redColor] frame:CGRectMake(CGRectGetMaxX(resetBtn.frame), ([UIScreen mainScreen].bounds.size.height - BTN_HEIGHT), width, BTN_HEIGHT)];

        [self addSubview:resetBtn];
        [self addSubview:confirmBtn];
    }
    return self;
}

- (UIButton *)customButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor selector:(SEL)selector bgColor:(UIColor *)bgColor frame:(CGRect)rect {

    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = rect;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setBackgroundColor:bgColor];
    [btn addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];

    //线
    CALayer * topLayer = [CALayer layer];
    topLayer.backgroundColor = [UIColor colorWithRed:(223.0/255.0) green:(224.0/255.0) blue:(225.0/255.0) alpha:1.0].CGColor;
    CGFloat layerHeight = 1.0;
    topLayer.frame = CGRectMake(0, 0, rect.size.width, layerHeight);
    [btn.layer addSublayer:topLayer];

    return btn;
}

#pragma mark set 方法

- (NSMutableArray *)selectedItems {
    if (!_selectedItems) {
        _selectedItems = [NSMutableArray array];
        for (int i = 0; i < self.dataArray.count; i++) {
            NSMutableArray * array = [NSMutableArray array];
            [_selectedItems addObject:array];
        }
    }
    return _selectedItems;
}

- (NSMutableArray *)dataDic {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }

    return _dataArray;
}

- (UIControl *)bgControl {
    if (!_bgControl) {
        _bgControl = [[UIControl alloc] initWithFrame:self.bounds];
        _bgControl.backgroundColor = [UIColor blackColor];
        [_bgControl addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchDown];
    }
    return _bgControl;
}

- (UITableView *)configTable {
    if (!_configTable) {
        _configTable = [[UITableView alloc] initWithFrame:CGRectMake(BLACK_WIDTH, 0, ([UIScreen mainScreen].bounds.size.width - BLACK_WIDTH), ([UIScreen mainScreen].bounds.size.height - BTN_HEIGHT)) style:UITableViewStylePlain];
        _configTable.dataSource = self;
        _configTable.delegate = self;
        _configTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _configTable.backgroundColor = [UIColor whiteColor];
    }

    return _configTable;
}

#pragma mark action

- (void)show {

    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];

    [self configViewAnimationBasedOriginX:0];
}

- (void)remove {

    [self configViewAnimationBasedOriginX:[UIScreen mainScreen].bounds.size.width];
}
//根据 originX 动画
- (void)configViewAnimationBasedOriginX:(CGFloat)originX {

    CGRect temp = self.frame;
    temp.origin.x = originX;
    CGFloat duration = 0.3;
    self.bgControl.alpha = 0.0;
    [UIView animateWithDuration:duration animations:^{
        self.frame = temp;
    } completion:^(BOOL finished) {
        self.bgControl.alpha = originX ? 0.0 : 0.3;
    }];
}

- (void)buttonClick:(UIButton *)btn {

    if ([btn.titleLabel.text isEqualToString:@"重置"]) {
        self.selectedItems = nil;
        [self.configTable reloadData];
    } else {
        [self remove];
        if (self.configViewDelegate && [self.configViewDelegate respondsToSelector:@selector(didConfirmEvent)]) {
            [self.configViewDelegate didConfirmEvent];
        }
    }
}

#pragma mark CRMConfigTableViewCellDelegate

- (void)didClickFoldEventAboutCell:(ConfigTableViewCell *)cell {

    //刷新当前cell
    NSIndexPath * indexPath = [self.configTable indexPathForCell:cell];
    [self.configTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];

    if (indexPath.row == (self.dataArray.count - 1)) {
        [self.configTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)configTableViewCell:(ConfigTableViewCell *)cell didSelectedItems:(NSMutableArray *)itemsArray {

    NSIndexPath * indexPath = [self.configTable indexPathForCell:cell];
    [self.selectedItems replaceObjectAtIndex:indexPath.row withObject:itemsArray];
}

#pragma mark UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary * contentDic = self.dataArray[indexPath.row];
    NSString * status = [contentDic objectForKey:STATUS];
    if ([status isEqualToString:@"YES"]) {
        return [[contentDic objectForKey:FOLD_HEIGHT] floatValue];
    } else {
        return [[contentDic objectForKey:UNFOLD_HEIGHT] floatValue];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ConfigTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ConfigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellDelegate = self;
    }

    NSMutableArray * selectedArray = [self.selectedItems objectAtIndex:indexPath.row];
    [cell drawCellContent:self.dataArray[indexPath.row] seletedItems:selectedArray];
    [cell hiddenSeperatorLine:(indexPath.row == (self.dataArray.count - 1))];

    return cell;
}

@end
