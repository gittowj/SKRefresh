//
//  UIView+SKRefreshComm.h
//  headTableView
//
//  Created by 魏娟 on 16/8/20.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Common.h"

#define kOpenedViewHeight   55
#define kMaxTopPadding      5
#define kMaxBottomPadding   6
#define kMaxDistance        100

/** 进入刷新状态的回调 */
typedef void (^SKRefreshComponentRefreshingBlock)();
/** 开始刷新后的回调(进入刷新状态后的回调) */
typedef void (^SKRefreshComponentbeginRefreshingCompletionBlock)();
/** 结束刷新后的回调 */
typedef void (^SKRefreshComponentEndRefreshingCompletionBlock)();

@class SKPopBasicRefreshView;
@interface SKRefreshComponent : UIControl {
    SKPopBasicRefreshView *_activity;
    BOOL _refreshing;
    BOOL _ignoreInset;
}
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalContentInset;
@property (nonatomic, assign) BOOL refreshing;

/** 进入刷新后的回调(进入刷新状态后的回调) */
@property (copy, nonatomic) SKRefreshComponentRefreshingBlock refreshingBlock;
/** 开始刷新后的回调(进入刷新状态后的回调) */
@property (copy, nonatomic) SKRefreshComponentbeginRefreshingCompletionBlock beginRefreshingCompletionBlock;
/** 结束刷新的回调 */
@property (copy, nonatomic) SKRefreshComponentEndRefreshingCompletionBlock endRefreshingCompletionBlock;

- (id)initInScrollView:(UIScrollView *)scrollView;

// use custom activity indicator
- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(SKPopBasicRefreshView *)activity;

// Tells the control that a refresh operation was started programmatically
- (void)beginRefreshing;

// Tells the control the refresh operation has ended
- (void)endRefreshing;

- (void)placeSubviews;

@end