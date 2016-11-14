//
//  ConfigView.h
//  MCRM
//
//  Created by mac on 16/10/24.
//
//筛选界面

#import <UIKit/UIKit.h>

@protocol ConfigViewDelegate;
@interface ConfigView : UIView

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,strong,readonly) NSMutableArray * selectedItems;
@property (nonatomic,weak) id<ConfigViewDelegate> configViewDelegate;

- (void)show;

@end

@protocol ConfigViewDelegate <NSObject>
@optional
- (void)didConfirmEvent;

@end
