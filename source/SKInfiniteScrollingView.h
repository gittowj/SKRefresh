//
//  UIView+SKInfiniteScrollingView.h
//  headTableView
//
//  Created by 魏娟 on 16/8/19.
//  Copyright © 2016年 魏娟. All rights reserved.
//


#import "SKRefreshComponent.h"

/*@interface SKInfiniteScrollingView : UIControl {
    SKPopBasicRefreshView *_activity;
    BOOL _refreshing;
    BOOL _ignoreInset;
}

@property (nonatomic, readonly, getter=isRefreshing) BOOL refreshing;

- (id)initInScrollView:(UIScrollView *)scrollView;

// use custom activity indicator
- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(SKPopBasicRefreshView *)activity;

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing;

// Tells the control the refresh operation has ended
- (void)endRefreshing;

@end*/

@interface SKInfiniteScrollingView : SKRefreshComponent
@end
