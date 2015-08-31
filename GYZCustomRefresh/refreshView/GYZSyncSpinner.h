//
//  GYZSyncSpinner.h
//  GYZCustomRefresh
//
//  Created by wito on 15/8/31.
//  Copyright (c) 2015年 gouyz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYZSyncSpinner : UIView

@property (assign, nonatomic) BOOL hidesWhenFinished;

- (void)startAnimating;
- (void)finish;

@end
