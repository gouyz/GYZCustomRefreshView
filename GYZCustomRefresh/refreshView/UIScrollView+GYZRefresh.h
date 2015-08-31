//
//  UIScrollView+GYZRefresh.h
//  GYZCustomRefresh
//
//  Created by wito on 15/8/31.
//  Copyright (c) 2015年 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (GYZRefresh)


/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeadWithCallback:(void (^)())callback;

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headBeginRefreshing;

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headEndRefreshing;

/**
 *  是否正在下拉刷新
 */
@property (nonatomic, assign, readonly, getter = isHeadRefreshing) BOOL headRefreshing;

@end
