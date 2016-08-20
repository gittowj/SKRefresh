//
//  UIView+PopRefreshController.h
//  headTableView
//
//  Created by 魏娟 on 16/8/18.
//  Copyright © 2016年 魏娟. All rights reserved.
//

/*#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class SKPopBasicRefreshView;
@interface SKPullToRefreshController : UIControl {
    SKPopBasicRefreshView *_activity;
    BOOL _refreshing;
    BOOL _canRefresh;
    BOOL _ignoreInset;
    BOOL _ignoreOffset;
    BOOL _didSetInset;
    BOOL _hasSectionHeaders;
    CGFloat _lastOffset;
}

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

- (id)initInScrollView:(UIScrollView *)scrollView;

// use custom activity indicator
- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(UIView *)activity;

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing;

// Tells the control the refresh operation has ended
- (void)endRefreshing;

@end*/



#import "SKRefreshComponent.h"

@interface SKPullToRefreshController : SKRefreshComponent

@end


