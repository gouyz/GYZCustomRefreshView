//
//  GYZRefreshBaseView.m
//  GYZCustomRefresh
//  刷新基类
//  Created by wito on 15/8/31.
//  Copyright (c) 2015年 gouyz. All rights reserved.
//

#import "GYZRefreshBaseView.h"

#define kArrowSize CGSizeMake(30.0f,30.0f)

@implementation GYZRefreshBaseView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        frame.size.height = kRefreshHeaderHeight;
        self.frame = frame;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [self setup];
    }
    
    return self;
}

-(void)setup
{
    [self addDownloadIndicators];
    
    if(!_textLabel)
    {
        _textLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_filledIndicator.frame) + 13.0f, CGRectGetMinY(_filledIndicator.frame), 150.0f, kArrowSize.height)];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.font = [UIFont systemFontOfSize:13.0f];
        _textLabel.textColor = [UIColor grayColor];
        [self addSubview:_textLabel];
    }
    
    self.state = GYZRefreshStateNormal;
}

- (void)addDownloadIndicators
{
    [_filledIndicator removeFromSuperview];
    _filledIndicator = nil;
    
    GYZRefreshCircleView *filledIndicator = [[GYZRefreshCircleView alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 80.0f, kRefreshHeaderHeight/2, kArrowSize.width, kArrowSize.height)];
    //    [filledIndicator setBackgroundColor:[UIColor whiteColor]];
    [filledIndicator setFillColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    [filledIndicator setStrokeColor:[UIColor colorWithRed:16./255 green:119./255 blue:234./255 alpha:1.0f]];
    filledIndicator.radiusPercent = 0.45;
    [self addSubview:filledIndicator];
    [filledIndicator loadIndicator];
    _filledIndicator = filledIndicator;
    [_filledIndicator setIndicatorAnimationDuration:1.0];
    
    self.spinner = [[GYZSyncSpinner alloc]initWithFrame:CGRectMake(4, 4, kArrowSize.width-8, kArrowSize.height-8)];
    self.spinner.hidesWhenFinished = NO;
    self.spinner.hidden = YES;
    [_filledIndicator addSubview:self.spinner];
}

-(void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    // 旧的父控件
    [self.superview removeObserver:self forKeyPath:kOffsetObserveKey context:nil];
    
    if (newSuperview) { // 新的父控件
        [newSuperview addObserver:self forKeyPath:kOffsetObserveKey options:NSKeyValueObservingOptionNew context:nil];
        
        // 记录UIScrollView
        _scrollView = (UIScrollView *)newSuperview;
        _scrollViewOriginalInset = _scrollView.contentInset;
    }
}

- (void)settingLabelText
{
    // 设置文字
    switch (self.state)
    {
        case GYZRefreshStateNormal:
        case GYZRefreshStatePulling:
            self.textLabel.text = @"下拉即可刷新...";
            break;
        case GYZRefreshStateWillRefreshing:
            self.textLabel.text = @"释放即可刷新...";
            break;
        case GYZRefreshStateRefreshing:
            self.textLabel.text = @"正在努力加载...";
            break;
        default:
            break;
    }
}

-(void)setState:(GYZRefreshState)state
{
    if(_scrollView.isDragging && state == GYZRefreshStatePulling)
    {
        CGFloat offset = _scrollView.contentOffset.y - _scrollViewOriginalInset.top;
        
        if(_filledIndicator.isHidden == NO)
        {
            self.spinner.hidden = YES;
            [_filledIndicator updateWithDownloadedBytes:MIN(-offset / kRefreshHeaderHeight, 1)];
        }
    }
    
    if(_state != state)
    {
        //存储当前的contentInset
        if (_state != GYZRefreshStateRefreshing) {
            _scrollViewOriginalInset = self.scrollView.contentInset;
        }
        
        switch (state)
        {
            case GYZRefreshStateNormal:
            {
            }
                break;
            case GYZRefreshStatePulling:
            {
                
            }
                break;
            case GYZRefreshStateRefreshing:
            {
                if(_filledIndicator.isHidden == NO)
                {
                    [_filledIndicator updateWithDownloadedBytes:1];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.spinner.hidden = NO;
                        [self.spinner startAnimating];
                    });
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self.spinner finish];
                    });
                }
                
                if(_beginRefreshCallback)
                {
                    _beginRefreshCallback();
                }
            }
                break;
            case GYZRefreshStateWillRefreshing:
                break;
            default:
                break;
        }
        
        _state = state;
        
        [self settingLabelText];
    }
}

#pragma mark 开始刷新
- (void)beginRefresh
{
    if (self.state == GYZRefreshStateRefreshing)
    {
        if (_beginRefreshCallback) {
            _beginRefreshCallback();
        }
    }
    else
    {
        self.state = GYZRefreshStateRefreshing;
    }
}

#pragma mark 结束刷新
- (void)endRefresh
{
    double delayInSeconds = 0.3f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.state = GYZRefreshStateNormal;
    });
}
@end
