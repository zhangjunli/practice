//
//  ConfigTableViewCell.m
//  MCRM
//
//  Created by mac on 16/10/24.
//
//

#import "ConfigTableViewCell.h"
#import "ScratchableLatexView.h"
#import "ScaleHotButton.h"
#import "UIColor+XXYExtension.h"

#define STATUS               @"status"
#define FOLD_HEIGHT          @"foldHeight"
#define UNFOLD_HEIGHT        @"unfoldHeight"
#define CELL_WIDTH           ([UIScreen mainScreen].bounds.size.width - 35)
#define kCustomerType        @"客户类型"

@interface ConfigTableViewCell ()<ScratchableLatexViewDelegate>

@property (nonatomic,strong) NSMutableDictionary * dictionary;
@property (nonatomic,strong) UILabel * titleLabel;//title label
@property (nonatomic,strong) ScaleHotButton * foldBtn;//折叠 button
@property (nonatomic,strong) UILabel * seperatorLine;//分割线
@property (nonatomic,strong) ScratchableLatexView * scratchableLatexView;//九宫格view

@end

@implementation ConfigTableViewCell

#pragma mark Initialization

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.foldBtn];
        [self.contentView addSubview:self.scratchableLatexView];
        [self.contentView addSubview:self.seperatorLine];
    }
    return self;
}

#pragma mark set 方法

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}

- (ScaleHotButton *)foldBtn {
    if (!_foldBtn) {
        _foldBtn = [ScaleHotButton buttonWithType:UIButtonTypeCustom];
        [_foldBtn setTitleColor:[UIColor colorWithHexString:@"#bbbbbb"] forState:UIControlStateNormal];
        [_foldBtn setTitle:@"全部" forState:UIControlStateNormal];
        _foldBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_foldBtn addTarget:self action:@selector(foldEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foldBtn;
}

- (ScratchableLatexView *)scratchableLatexView {
    if (!_scratchableLatexView) {
        _scratchableLatexView = [[ScratchableLatexView alloc] init];
        _scratchableLatexView.scratchableLatexDelegate = self;
    }
    return _scratchableLatexView;
}

- (UILabel *)seperatorLine {
    if (!_seperatorLine) {
        _seperatorLine = [[UILabel alloc] init];
        _seperatorLine.backgroundColor = [UIColor colorWithRed:(223.0/255.0) green:(224.0/255.0) blue:(225.0/255.0) alpha:1.0];
    }
    return _seperatorLine;
}

#pragma mark draw cell

- (void)drawCellContent:(NSMutableDictionary *)contentDic seletedItems:(NSMutableArray *)seletedItems {

    self.dictionary = contentDic;
    NSArray * keyArray = contentDic.allKeys;
    //title 赋值
    for (NSString * key in keyArray) {
        if (![key isEqualToString:UNFOLD_HEIGHT] && ![key isEqualToString:FOLD_HEIGHT] && ![key isEqualToString:STATUS]) {

            self.titleLabel.text = key;
            break;
        }
    }

    //修改btn 文字和图片
    NSString * status = [contentDic objectForKey:STATUS];
    [self changeBtn:self.foldBtn basedStatus:[status isEqualToString:@"YES"]];
    //折叠 button 是否显示
    NSArray * titleArray = [contentDic objectForKey:self.titleLabel.text];
    self.foldBtn.hidden = (titleArray.count <= 3);
    //创建 button
    BOOL isFold = [status isEqualToString:@"YES"];
    UIChoiceType type = [self.titleLabel.text isEqualToString:kCustomerType] ? UIChoiceTypeSingle : UIChoiceTypeMultiple;
    [self.scratchableLatexView addButtonsOfScratchableLatexLayout:titleArray selectedItems:seletedItems isFold:isFold choiceType:type];
}

#pragma mark action

- (void)foldEvent:(UIButton *)btn {

   //修改数据源数据
    NSString * status = [self.dictionary objectForKey:STATUS];
    if ([status isEqualToString:@"NO"]) {
        status = @"YES";
    } else {
        status = @"NO";
    }
    [self.dictionary setObject:status forKey:STATUS];
    //修改btn 文字和图片
    [self changeBtn:btn basedStatus:[status isEqualToString:@"YES"]];

    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickFoldEventAboutCell:)]) {
        [self.cellDelegate didClickFoldEventAboutCell:self];
    }
}

- (void)changeBtn:(UIButton *)btn basedStatus:(BOOL)status {

    NSString * imageName = status ? @"icon_zhankai" : @"icon_shouqi";
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)hiddenSeperatorLine:(BOOL)isHidden {

    self.seperatorLine.hidden = isHidden;
}

#pragma mark 设置frame

- (void)layoutSubviews {
    [super layoutSubviews];

    //设置frame
    //title label
    CGSize keySize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGFloat titleX = 12;
    CGFloat titleY = 16;

   self.titleLabel.frame = CGRectMake(titleX, titleY, keySize.width, keySize.height);

    //全部 button
    UIImage * arrowImg = [UIImage imageNamed:@"icon_shouqi"];
    CGSize size = [self.foldBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.foldBtn.titleLabel.font}];
    CGFloat space = 4;//是图片和文字间的间隙
    CGFloat rightMargin = 15.5;
    CGFloat width = (arrowImg.size.width + size.width + space);
    CGFloat originX = (CELL_WIDTH - rightMargin - width);

    self.foldBtn.frame = CGRectMake(originX, titleY, width, size.height);
    [self.foldBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -arrowImg.size.width, 0, (arrowImg.size.width+space))];
    [self.foldBtn setImageEdgeInsets:UIEdgeInsetsMake(0, (size.width+space), 0, -size.width)];

    //九宫格view
    self.scratchableLatexView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CELL_WIDTH, self.scratchableLatexView.height);

    //分割线
    CGFloat lineHeight = 1.0;
    CGFloat cellHeight = CGRectGetMaxY(self.scratchableLatexView.frame);
    self.seperatorLine.frame = CGRectMake(0, (cellHeight - lineHeight), CELL_WIDTH, lineHeight);
}

#pragma mark ScratchableLatexViewDelegate

- (void)scratchableLatexView:(ScratchableLatexView *)view didSelectedItems:(NSMutableArray *)items {

    if (self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(configTableViewCell:didSelectedItems:)]) {
        [self.cellDelegate configTableViewCell:self didSelectedItems:items];
    }
}

@end
