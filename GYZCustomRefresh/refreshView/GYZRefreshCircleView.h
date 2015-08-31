//
//  GYZRefreshCircleView.h
//  GYZCustomRefresh
//
//  Created by wito on 15/8/31.
//  Copyright (c) 2015年 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYZRefreshCircleView : UIView

// this value should be 0 to 0.5 (default: (kRMFilledIndicator = 0.5), (kRMMixedIndictor = 0.4))
@property(nonatomic, assign)CGFloat radiusPercent;

// used to fill the downloaded percent slice (default: (kRMFilledIndicator = white), (kRMMixedIndictor = white))
@property(nonatomic, strong)UIColor *fillColor;

// used to stroke the covering slice (default: (kRMClosedIndicator = white), (kRMMixedIndictor = white))
@property(nonatomic, strong)UIColor *strokeColor;

// used to stroke the background path the covering slice (default: (kRMClosedIndicator = gray))
@property(nonatomic, strong)UIColor *closedIndicatorBackgroundStrokeColor;

// prepare the download indicator
- (void)loadIndicator;

// update the downloadIndicator
- (void)setIndicatorAnimationDuration:(CGFloat)duration;

// update the downloadIndicator
- (void)updateWithDownloadedBytes:(CGFloat)downloadedBytes;

@end
