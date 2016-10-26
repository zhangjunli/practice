//
//  CRMPageNumberView.m
//  MCRM
//
//  Created by mac on 16/10/25.
//
//

#import "CRMPageNumberView.h"

@interface CRMPageNumberView ()

@property (nonatomic,strong) UILabel * currentPage;
@property (nonatomic,strong) UILabel * line;
@property (nonatomic,strong) UILabel * totalPage;
@property (nonatomic,strong) UIImageView * topImgView;
@property (nonatomic,assign) BOOL lastHiddenStatus;

@end

@implementation CRMPageNumberView

#pragma mark 初始化 方法

- (instancetype)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        //设置边框
        self.layer.cornerRadius = frame.size.width/2.0;
        self.layer.masksToBounds = YES;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0;
        //设置背景
        self.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1.0];
        //布局
        [self addSubview:self.currentPage];
        [self addSubview:self.line];
        [self addSubview:self.totalPage];
        [self addSubview:self.topImgView];
    }

    return self;
}

#pragma mark set 方法

- (void)setIsTopImageHidden:(BOOL)isTopImageHidden {

    //同一设置，只设置一次。 起过滤作用
    if (self.lastHiddenStatus != isTopImageHidden) {
        //更改状态
        self.lastHiddenStatus = isTopImageHidden;

        self.topImgView.hidden = isTopImageHidden;
        self.currentPage.hidden = !isTopImageHidden;
        self.line.hidden = !isTopImageHidden;
        self.totalPage.hidden = !isTopImageHidden;
    }
}


- (void)setCurrentPageNumber:(int)currentPageNumber {

    _currentPageNumber = currentPageNumber;
    _currentPage.text = [NSString stringWithFormat:@"%d",currentPageNumber];
}

- (void)setTotalPageNumber:(int)totalPageNumber {

    _totalPageNumber = totalPageNumber;
    _totalPage.text = [NSString stringWithFormat:@"%d",totalPageNumber];
}

#pragma mark get 方法

- (UILabel *)currentPage {

    if (!_currentPage) {
        CGFloat margin = 5;
        CGFloat originY = self.frame.size.height*1.5/8.0;
        CGFloat height = self.frame.size.height/4.0;
        CGFloat width = (self.frame.size.width - margin*2);
        _currentPage = [[UILabel alloc] initWithFrame:CGRectMake(margin, originY, width, height)];
        _currentPage.text = @"5";
        _currentPage.textColor = [UIColor blackColor];
        _currentPage.textAlignment = NSTextAlignmentCenter;
        _currentPage.font = [UIFont systemFontOfSize:11.0];
        _currentPage.adjustsFontSizeToFitWidth = YES;
    }
    return _currentPage;
}

- (UILabel *)line {

    if (!_line) {
        CGFloat margin = 8;
        CGFloat originY = self.frame.size.height/2.0;
        CGFloat width = (self.frame.size.width - margin*2);
        CGFloat height = 1.0;
        _line = [[UILabel alloc] initWithFrame:CGRectMake(margin, originY, width, height)];
        _line.backgroundColor = [UIColor blackColor];
    }
    return _line;
}

- (UILabel *)totalPage {

    if (!_totalPage) {
        CGFloat margin = 5;
        CGFloat originY = self.frame.size.height * 4.5/8.0 ;
        CGFloat height = self.frame.size.height/4.0;
        CGFloat width = (self.frame.size.width - margin*2);
        _totalPage = [[UILabel alloc] initWithFrame:CGRectMake(margin, originY, width, height)];
        _totalPage.text = @"40";
        _totalPage.textColor = [UIColor blackColor];
        _totalPage.textAlignment = NSTextAlignmentCenter;
        _totalPage.font = [UIFont systemFontOfSize:11.0];
        _totalPage.adjustsFontSizeToFitWidth = YES;
    }
    return _totalPage;
}

- (UIImageView *)topImgView {

    if (!_topImgView) {

        UIImage * topImg = [UIImage imageNamed:@"iconfont-dingbu"];
        _topImgView = [[UIImageView alloc] initWithImage:topImg];
        _topImgView.frame = self.bounds;
        _topImgView.contentMode = UIViewContentModeCenter;
        _topImgView.backgroundColor = self.backgroundColor;

        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [_topImgView addGestureRecognizer:tapGesture];
        _topImgView.userInteractionEnabled = YES;
        _topImgView.hidden = YES;
    }
    return _topImgView;
}

- (void)tapClick:(UIGestureRecognizer *)tapGesture {

    if (self.pageDelegate && [self.pageDelegate respondsToSelector:@selector(didTriggerEventOfBackingToTop)]) {
        [self.pageDelegate didTriggerEventOfBackingToTop];
    }
}

@end
