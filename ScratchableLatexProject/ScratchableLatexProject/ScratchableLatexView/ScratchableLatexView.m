//
//  CRMScratchableLatexView.m
//  MCRM
//
//  Created by mac on 16/10/31.
//
//

#import "ScratchableLatexView.h"
#import "ScaleHotButton.h"
#import "UIColor+XXYExtension.h"

#define BTN_TAG         10
#define VIEW_WIDTH      ([UIScreen mainScreen].bounds.size.width - 35)
#define BTN_HEIGHT      30
#define FIXED_HEIGHT    38.5
#define VERTICAL_SPACE  12 //btn 竖直方向间距

@interface ScratchableLatexView ()

@property (nonatomic,strong) NSArray * dataArray;
@property (nonatomic,assign) BOOL isFold;
@property (nonatomic,strong) UIButton * lastSelected;
@property (nonatomic,assign) UIChoiceType choiceType;
@property (nonatomic,strong) NSMutableArray * selectedArray;

@end

@implementation ScratchableLatexView

#pragma mark set function

- (CGFloat)height {
    if (self.isFold) {//折叠
        return (FIXED_HEIGHT+BTN_HEIGHT);
    } else { //展开
        int row = ((int)self.dataArray.count - 1) / 3;
        return (FIXED_HEIGHT+(row+1)*BTN_HEIGHT+row*VERTICAL_SPACE);
    }
}

- (NSMutableArray *)selectedArray {

    if (!_selectedArray) {
        _selectedArray = [NSMutableArray array];
    }
    return _selectedArray;
}

#pragma mark 九宫格布局

- (void)addButtonsOfScratchableLatexLayout:(NSArray *)scratchableLatexArray selectedItems:(NSMutableArray *)seletedItems isFold:(BOOL)isFold choiceType:(UIChoiceType)type {

    //移除
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[ScaleHotButton class]]) {
            ScaleHotButton * btn = (ScaleHotButton *)obj;
            [btn removeFromSuperview];
            btn = nil;
        }
    }];

    self.dataArray = scratchableLatexArray;
    self.isFold = isFold;
    self.choiceType = type;
    self.selectedArray = seletedItems;

    //添加
    NSInteger maxCount = (scratchableLatexArray.count > 3) ? (self.isFold ? 3 : scratchableLatexArray.count) : scratchableLatexArray.count;
    for (NSInteger i = 0; i < maxCount; i++) {

        NSString * title = [scratchableLatexArray objectAtIndex:i];
        ScaleHotButton * btn = [ScaleHotButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"#e14238"] forState:UIControlStateSelected];
        [btn setImage:[UIImage imageNamed:@"icon_xuan"] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(buttonTouchInsideClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(buttonDownClick:) forControlEvents:UIControlEventTouchDown];
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.tag = BTN_TAG+i;

        BOOL isSelected = [seletedItems containsObject:title];
        btn.selected = isSelected;
        [self changeBtn:btn selectedState:btn.selected];

        [self addSubview:btn];
    }
}
//修改点击时btn 颜色
- (void)buttonDownClick:(UIButton *)btn {
    if (btn.selected) {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#f0f2f4"]];
        btn.layer.borderColor = btn.backgroundColor.CGColor;
    } else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateHighlighted];
    }
}

- (void)buttonTouchInsideClick:(UIButton *)btn {
    //设置选中
    btn.selected = !btn.selected;
    [self changeBtn:btn selectedState:btn.selected];
    [self executeSingleChoiceLogical:btn];

    //选中的存入数组
    if (btn.selected) {
        [self.selectedArray addObject:btn.titleLabel.text];
    }else {
        if ([self.selectedArray containsObject:btn.titleLabel.text]) {
            [self.selectedArray removeObject:btn.titleLabel.text];
        }
    }

    if (self.scratchableLatexDelegate && [self.scratchableLatexDelegate respondsToSelector:@selector(scratchableLatexView:didSelectedItems:)]) {
        [self.scratchableLatexDelegate scratchableLatexView:self didSelectedItems:self.selectedArray];
    }
}

//button 状态的改变
- (void)changeBtn:(UIButton *)btn selectedState:(BOOL)isSelected {

    if (isSelected) {
        //修改边框颜色，字体颜色，背景色，加图片
        btn.layer.borderColor = [UIColor colorWithHexString:@"#e14238"].CGColor;
        [btn setBackgroundColor:[UIColor whiteColor]];
        int space = 2;
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, space, 0, 0)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -space, 0, 0)];
    } else {
        [btn setBackgroundColor:[UIColor colorWithHexString:@"#f0f2f4"]];
        btn.layer.borderColor = btn.backgroundColor.CGColor;
    }
}

- (void)executeSingleChoiceLogical:(UIButton *)btn {
    //处理单选逻辑
    if (self.choiceType == UIChoiceTypeSingle) {

        if (![self.lastSelected.titleLabel.text isEqualToString:btn.titleLabel.text] && self.lastSelected.selected) {
            [self cancelSeletedStatusOfLastButtton:self.lastSelected];
        }
        //纪录当前选中button
        self.lastSelected = btn;
    }
}

- (void)cancelSeletedStatusOfLastButtton:(UIButton *)btn {
    //改变状态
    btn.selected = NO;
    [self changeBtn:btn selectedState:btn.isSelected];
    //从选中数组中移除
    if ([self.selectedArray containsObject:btn.titleLabel.text]) {
        [self.selectedArray removeObject:btn.titleLabel.text];
    }
}

#pragma mark 设置frame

- (void)layoutSubviews {
    [super layoutSubviews];

    NSInteger maxCount = (self.dataArray.count > 3) ? (self.isFold ? 3 : self.dataArray.count) : self.dataArray.count;
    for (NSInteger i = 0; i < maxCount; i++) {

        CGFloat leftMargin = 12;// btn 离 相邻 cell左边界 间距
        CGFloat rightMargin = 15.5;// btn 离 相邻 cell右边界 间距
        CGFloat topMargin = 19;// btn 离 相邻 上边界 间距
        CGFloat horizontalSpace = 6.5; //btn间  水平方向间距
        CGFloat width = (VIEW_WIDTH - leftMargin - rightMargin - horizontalSpace*2)/3.0; //控件 宽度
        NSInteger row = i/3; //行
        NSInteger col = i%3;//列

        UIButton * btn = (UIButton *)[self viewWithTag:(BTN_TAG+i)];
        btn.frame = CGRectMake(leftMargin + col*(width+horizontalSpace), topMargin+row*(BTN_HEIGHT+VERTICAL_SPACE), width, BTN_HEIGHT);
    }
}

@end
