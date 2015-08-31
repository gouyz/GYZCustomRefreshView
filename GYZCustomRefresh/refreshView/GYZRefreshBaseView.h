//
//  GYZRefreshBaseView.h
//  GYZCustomRefresh
//
//  Created by wito on 15/8/31.
//  Copyright (c) 2015年 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYZSyncSpinner.h"
#import "GYZRefreshCircleView.h"

#define kRefreshHeaderHeight 80.0f
#define kRefreshFooterHeight 80.0f
#define kOffsetObserveKey @"contentOffset"
#define kContentSizeObserveKey @"contentSize"

typedef NS_ENUM(NSInteger, GYZRefreshState)
{
    GYZRefreshStateNone,
    GYZRefreshStatePulling,        // 松开就可以进行刷新的状态
    GYZRefreshStateNormal,         // 普通状态
    GYZRefreshStateRefreshing,     // 正在刷新中的状态
    GYZRefreshStateWillRefreshing
};

@interface GYZRefreshBaseView : UIView

@property (nonatomic,strong,readonly) UILabel *textLabel;
@property (nonatomic,strong,readonly) UIImageView *backgroundImageView;
@property (nonatomic,strong,readonly) GYZRefreshCircleView *filledIndicator;
@property (nonatomic,strong) GYZSyncSpinner *spinner;

@property (nonatomic,weak,readonly) UIScrollView *scrollView;
@property (nonatomic,assign,readonly) UIEdgeInsets scrollViewOriginalInset;

@property (nonatomic,assign) GYZRefreshState state;
@property (nonatomic,assign) BOOL isInitFooter;

@property (nonatomic,copy) void (^beginRefreshCallback)();

- (void)settingLabelText;

-(void)beginRefresh;
-(void)endRefresh;

@end
