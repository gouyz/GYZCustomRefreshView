//
//  GYZRefreshHeadView.m
//  GYZCustomRefresh
//  下拉刷新
//  Created by wito on 15/8/31.
//  Copyright (c) 2015年 gouyz. All rights reserved.
//

#import "GYZRefreshHeadView.h"

@implementation GYZRefreshHeadView

+(instancetype)header
{
    return [[GYZRefreshHeadView alloc]init];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    CGRect frect = self.frame;
    frect.origin.y = -frect.size.height;
    self.frame = frect;
}

/**
 *  调整状态
 */
- (void)adjustStateWithContentOffset
{
    // 当前的contentOffset
    CGFloat currentOffsetY = self.scrollView.contentOffset.y;
    // 头部控件刚好出现的offsetY
    CGFloat happenOffsetY = -self.scrollViewOriginalInset.top;
    
    // 如果是向上滚动到看不见头部控件，直接返回
    if (currentOffsetY >= happenOffsetY)
    {
        return;
    }
    
    CGFloat normal2pullingOffsetY = happenOffsetY - self.bounds.size.height;
    if (self.scrollView.isDragging)
    {
        // 普通 和 即将刷新 的临界点
        if (self.state == GYZRefreshStateNormal && currentOffsetY < happenOffsetY)
        {
            //转为下拉状态
            self.state = GYZRefreshStatePulling;
        }
        if(currentOffsetY > normal2pullingOffsetY)
        {
            self.state = GYZRefreshStatePulling;
        }
        if(self.state == GYZRefreshStatePulling && currentOffsetY < normal2pullingOffsetY)
        {
            // 转为即将刷新状态
            self.state = GYZRefreshStateWillRefreshing;
        }
    }
    else
    {
        if (self.state == GYZRefreshStatePulling)
        {
            if (currentOffsetY >= normal2pullingOffsetY) {
                // 转为普通状态
                self.state = GYZRefreshStateNormal;
            }
        }
        else if(self.state == GYZRefreshStateWillRefreshing)
        {
            // 即将刷新 && 手松开
            self.state = GYZRefreshStateRefreshing;
        }
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:kOffsetObserveKey])
    {
        if(self.state != GYZRefreshStateRefreshing)
        {
            [self adjustStateWithContentOffset];
        }
    }
}

-(void)setState:(GYZRefreshState)state
{
    if(state == GYZRefreshStatePulling && self.state == GYZRefreshStatePulling)
    {
        [super setState:state];
    }
    if(self.state != state)
    {
        GYZRefreshState oldState = self.state;
        
        [super setState:state];
        
        switch (state) {
            case GYZRefreshStateNormal:
            {
                if(oldState == GYZRefreshStateRefreshing)
                {
                    [UIView animateWithDuration:2.0f animations:^{
                        UIEdgeInsets inset = self.scrollView.contentInset;
                        inset.top -= self.bounds.size.height;
                        self.scrollView.contentInset = inset;
                    }];
                }
            }
                break;
            case GYZRefreshStatePulling:
                break;
            case GYZRefreshStateRefreshing:
            {
                [UIView animateWithDuration:1.0f animations:^{
                    UIEdgeInsets inset = self.scrollView.contentInset;
                    inset.top = self.scrollViewOriginalInset.top + self.bounds.size.height;
                    self.scrollView.contentInset = inset;
                    
                    CGPoint offset = self.scrollView.contentOffset;
                    offset.y = -inset.top;
                    self.scrollView.contentOffset = offset;
                }];
            }
                break;
            default:
                break;
        }
    }
}

@end
