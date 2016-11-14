//
//  ScratchableLatexView.h
//  MCRM
//
//  Created by mac on 16/10/31.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIChoiceType) {
    UIChoiceTypeSingle = 1,
    UIChoiceTypeMultiple
};
@protocol ScratchableLatexViewDelegate;
@interface ScratchableLatexView : UIView

@property (nonatomic,assign,readonly) CGFloat height;
@property (nonatomic,weak) id<ScratchableLatexViewDelegate> scratchableLatexDelegate;

//带有 九宫格布局的 button
- (void)addButtonsOfScratchableLatexLayout:(NSArray *)scratchableLatexArray selectedItems:(NSMutableArray *)seletedItems isFold:(BOOL)isFold choiceType:(UIChoiceType)type;

@end

@protocol ScratchableLatexViewDelegate <NSObject>

@optional

- (void)scratchableLatexView:(ScratchableLatexView *)view didSelectedItems:(NSMutableArray *)items;

@end
