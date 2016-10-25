//
//  CRMPageNumberView.h
//  MCRM
//
//  Created by mac on 16/10/25.
//
//

#import <UIKit/UIKit.h>

@protocol CRMPageNumberViewDelegate;

@interface CRMPageNumberView : UIView

@property (nonatomic,assign) BOOL isTopImageHidden;
@property (nonatomic,assign) int currentPageNumber;
@property (nonatomic,assign) int totalPageNumber;
@property (nonatomic,assign) id<CRMPageNumberViewDelegate> pageDelegate;

@end

@protocol CRMPageNumberViewDelegate <NSObject>

//触发置顶 事件
- (void)didTriggerEventOfBackingToTop;

@end
