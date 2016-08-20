//
//  UIView+PopRefreshController.m
//  headTableView
//
//  Created by 魏娟 on 16/8/18.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import "SKPullToRefreshController.h"
#import "SKPopRefreshView.h"

/*#define kTotalViewHeight    400
#define kOpenedViewHeight   55
#define kMinTopPadding      9
#define kMaxTopPadding      5
#define kMinBottomPadding   4
#define kMaxBottomPadding   6
#define kMaxDistance        53

@interface SKPullToRefreshController ()

@property (nonatomic, readwrite) BOOL refreshing;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalContentInset;

@end

@implementation SKPullToRefreshController

@synthesize refreshing = _refreshing;

@synthesize scrollView = _scrollView;
@synthesize originalContentInset = _originalContentInset;


- (id)initInScrollView:(UIScrollView *)scrollView {
    return [self initInScrollView:scrollView activityIndicatorView:nil];
}

- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(UIView *)activity
{
    self = [super initWithFrame:CGRectMake(0, -(kTotalViewHeight + scrollView.contentInset.top), scrollView.frame.size.width, kTotalViewHeight)];
    
    if (self) {
        self.scrollView = scrollView;
        
        self.originalContentInset = scrollView.contentInset;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
        
        _activity = activity ? activity : [[SKPopBasicRefreshView alloc] initWithFrame:CGRectZero];
        _activity.center = CGPointMake(floor(self.frame.size.width / 2), floor(self.frame.size.height / 2));
        _activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _activity.alpha = 0;
        
        CGRect frame = _activity.frame;
        frame.size.height = kOpenedViewHeight;
        frame.size.width = self.scrollView.frame.size.width;
        
        _activity.frame = frame;
        [self addSubview:_activity];
        
        _refreshing = NO;
        _canRefresh = YES;
        _ignoreInset = NO;
        _ignoreOffset = NO;
        _didSetInset = NO;
        _hasSectionHeaders = NO;
        
       
        
    }
    return self;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    self.scrollView = nil;
}

- (void)setEnabled:(BOOL)enabled
{
    super.enabled = enabled;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
        self.scrollView = nil;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentInset"]) {
        if (!_ignoreInset) {
            self.originalContentInset = [[change objectForKey:@"new"] UIEdgeInsetsValue];
            self.frame = CGRectMake(0, -(kTotalViewHeight + self.scrollView.contentInset.top), self.scrollView.frame.size.width, kTotalViewHeight);
        }
        return;
    }
    
    if (!self.enabled || _ignoreOffset) {
        return;
    }
    
    CGFloat offset = [[change objectForKey:@"new"] CGPointValue].y + self.originalContentInset.top;
    
    if (_refreshing) {
        if (offset != 0) {
            // Keep thing pinned at the top
            _activity.center = CGPointMake(floor(self.frame.size.width / 2), MIN(offset + self.frame.size.height + floor(kOpenedViewHeight / 2), self.frame.size.height - kOpenedViewHeight/ 2));
            
            _ignoreInset = YES;
            _ignoreOffset = YES;
            
            if (offset > 0) {
                // Set the inset depending on the situation
                if (offset >= kOpenedViewHeight) {
                    if (!self.scrollView.dragging) {
                        if (!_didSetInset) {
                            _didSetInset = YES;
                            _hasSectionHeaders = NO;
                            if([self.scrollView isKindOfClass:[UITableView class]]){
                                for (int i = 0; i < [(UITableView *)self.scrollView numberOfSections]; ++i) {
                                    if ([(UITableView *)self.scrollView rectForHeaderInSection:i].size.height) {
                                        _hasSectionHeaders = YES;
                                        break;
                                    }
                                }
                            }
                        }
                        if (_hasSectionHeaders) {
                            [self.scrollView setContentInset:UIEdgeInsetsMake(MIN(-offset, kOpenedViewHeight) - self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                        } else {
                            [self.scrollView setContentInset:UIEdgeInsetsMake(kOpenedViewHeight - self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                        }
                    } else if (_didSetInset && _hasSectionHeaders) {
                        [self.scrollView setContentInset:UIEdgeInsetsMake(-offset - self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
                    }
                }
            } else if (_hasSectionHeaders) {
                [self.scrollView setContentInset:self.originalContentInset];
            }
            _ignoreInset = NO;
            _ignoreOffset = NO;
        }
        return;
        
        
        
    } else {
        // Check if we can trigger a new refresh and if we can draw the control
        BOOL dontDraw = NO;
        if (!_canRefresh) {
            if (offset >= 0) {
                // We can refresh again after the control is scrolled out of view
                _canRefresh = YES;
                _didSetInset = NO;
            } else {
                dontDraw = YES;
            }
        } else {
            if (offset >= 0) {
                // Don't draw if the control is not visible
                dontDraw = YES;
            }
        }
        if (offset > 0 && _lastOffset > offset && !self.scrollView.isTracking) {
            // If we are scrolling too fast, don't draw, and don't trigger unless the scrollView bounced back
            _canRefresh = NO;
            dontDraw = YES;
        }
        if (dontDraw) {
            _lastOffset = offset;
            return;
        }
    }
    
    _lastOffset = offset;
    
    BOOL triggered = NO;
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    //Calculate some useful points and values
    CGFloat verticalShift = MAX(0, -((kMaxTopPadding + kMaxBottomPadding) - offset));
    CGFloat distance = MIN(kMaxDistance, fabs(verticalShift));
    CGFloat percentage = 1 - (distance / kMaxDistance);
    
    if (distance != 0) {
        if (percentage == 0) {
            triggered = YES;
        }
    }
    
    if (triggered) {
        
        [(SKPopBasicRefreshView *)_activity startAnimating];
        self.refreshing = YES;
        _canRefresh = NO;
        
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    }
    
    CGPathRelease(path);
}

- (void)beginRefreshing
{
    if (!_refreshing) {
        CGPoint offset = self.scrollView.contentOffset;
        _ignoreInset = YES;
        [self.scrollView setContentInset:UIEdgeInsetsMake(kOpenedViewHeight + self.originalContentInset.top, self.originalContentInset.left, self.originalContentInset.bottom, self.originalContentInset.right)];
        _ignoreInset = NO;
        [self.scrollView setContentOffset:offset animated:NO];
        
        
        self.refreshing = YES;
        _canRefresh = NO;
    }
}

- (void)endRefreshing
{
    if (_refreshing) {
        self.refreshing = NO;
        __block UIScrollView *blockScrollView = self.scrollView;
        
        
        [UIView animateWithDuration:1 animations:^{
            _ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            
            _ignoreInset = NO;
        } completion:^(BOOL finished) {
            _ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            [(SKPopBasicRefreshView *)_activity stopAnimating];
            _ignoreInset = NO;
            
        }];
    }
}

@end*/

@implementation SKPullToRefreshController

- (void)placeSubviews{
    [self setFrame:CGRectMake(0, -(kOpenedViewHeight + self.scrollView.bounds.origin.y), self.scrollView.frame.size.width, kOpenedViewHeight)];
}

#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)getDraggingOffset:(CGFloat)y{
    if (y >= 0) {
        return 0;
    }
    return -(y+ self.originalContentInset.top);
}

- (void)beginRefreshing
{
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
    
    if (!_refreshing) {
        self.refreshing = YES;
        CGFloat top = self.originalContentInset.top + kOpenedViewHeight;
        
        __block UIScrollView *blockScrollView = self.scrollView;
        [UIView animateWithDuration:1 animations:^{
            _ignoreInset = YES;
            
            blockScrollView.insetT = top;
            blockScrollView.offsetY = -top;
            
        } completion:^(BOOL finished) {
            blockScrollView.insetT = top;
            blockScrollView.offsetY = -top;
            _ignoreInset = NO;
            
            _activity.center = CGPointMake(floor(self.frame.size.width / 2), floor(self.frame.size.height / 2));
            
            [(SKPopBasicRefreshView *)_activity startAnimating];
            if (self.beginRefreshingCompletionBlock) {
                self.beginRefreshingCompletionBlock();
            }
            
        }];
        
    }
}

- (void)endRefreshing
{
    if (_refreshing) {
        self.refreshing = NO;
        __block UIScrollView *blockScrollView = self.scrollView;
        [UIView animateWithDuration:1 animations:^{
            _ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            
            _ignoreInset = NO;
        } completion:^(BOOL finished) {
            _ignoreInset = YES;
            [blockScrollView setContentInset:self.originalContentInset];
            [(SKPopBasicRefreshView *)_activity stopAnimating];
            _ignoreInset = NO;
            
        }];
    }
}
@end



