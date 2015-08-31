//
//  UIScrollView+GYZRefresh.m
//  GYZCustomRefresh
//  UIScrollView category
//  Created by wito on 15/8/31.
//  Copyright (c) 2015年 gouyz. All rights reserved.
//

#import "UIScrollView+GYZRefresh.h"
#import "GYZRefreshHeadView.h"
#import <objc/runtime.h>


@interface UIScrollView()

@property (weak, nonatomic) GYZRefreshHeadView *header;

@end

@implementation UIScrollView (GYZRefresh)

#pragma mark - 运行时相关
static char GYZRefreshHeaderViewKey;

- (void)setHeader:(GYZRefreshHeadView *)header {
    [self willChangeValueForKey:@"GYZRefreshHeaderViewKey"];
    objc_setAssociatedObject(self, &GYZRefreshHeaderViewKey,
                             header,
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"GYZRefreshHeaderViewKey"];
}

- (GYZRefreshHeadView *)header {
    return objc_getAssociatedObject(self, &GYZRefreshHeaderViewKey);
}


/**
 *  添加一个下拉刷新头部控件
 *
 *  @param callback 回调
 */
- (void)addHeadWithCallback:(void (^)())callback
{
    // 1.创建新的header
    if (!self.header) {
        GYZRefreshHeadView *header = [GYZRefreshHeadView header];
        [self addSubview:header];
        self.header = header;
    }
    
    // 2.设置block回调
    self.header.beginRefreshCallback = callback;
}

/**
 *  主动让下拉刷新头部控件进入刷新状态
 */
- (void)headBeginRefreshing
{
    [self.header beginRefresh];
}

/**
 *  让下拉刷新头部控件停止刷新状态
 */
- (void)headEndRefreshing
{
    [self.header endRefresh];
}

- (BOOL)isHeadRefreshing
{
    return self.header.state == GYZRefreshStateRefreshing;
}

@end
