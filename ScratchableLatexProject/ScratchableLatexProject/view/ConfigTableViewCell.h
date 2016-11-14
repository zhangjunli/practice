//
//  ConfigTableViewCell.h
//  MCRM
//
//  Created by mac on 16/10/24.
//
//

#import <UIKit/UIKit.h>

@protocol ConfigTableViewCellDelegate;

@interface ConfigTableViewCell : UITableViewCell
@property (nonatomic,weak) id<ConfigTableViewCellDelegate> cellDelegate;

//cell 的赋值操作
- (void)drawCellContent:(NSMutableDictionary *)contentDic seletedItems:(NSMutableArray *)seletedItems;

//设置线的隐藏和显示
- (void)hiddenSeperatorLine:(BOOL)isHidden;

@end

@protocol ConfigTableViewCellDelegate <NSObject>

@optional

- (void)didClickFoldEventAboutCell:(ConfigTableViewCell *)cell;
- (void)configTableViewCell:(ConfigTableViewCell *)cell didSelectedItems:(NSMutableArray *)itemsArray;

@end
