//
//  UIView+SKRefreshComm.m
//  headTableView
//
//  Created by 魏娟 on 16/8/20.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import "SKRefreshComponent.h"
#import "SKPopRefreshView.h"


@interface SKRefreshComponent ()
@end

@implementation SKRefreshComponent

@synthesize refreshing = _refreshing;
@synthesize scrollView = _scrollView;
@synthesize originalContentInset = _originalContentInset;

- (id)initInScrollView:(UIScrollView *)scrollView {
    return [self initInScrollView:scrollView activityIndicatorView:nil];
}

- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(SKPopBasicRefreshView *)activity
{
    self = [super initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, kOpenedViewHeight)];
    
    if (self) {
        self.scrollView = scrollView;
        self.originalContentInset = scrollView.contentInset;
        
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [scrollView addSubview:self];
        [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentInset" options:NSKeyValueObservingOptionNew context:nil];
        [scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        _activity = activity ? activity : [[SKPopBasicRefreshView alloc] initWithFrame:CGRectZero];
        _activity.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _activity.alpha = 0;
        
        CGRect frame = _activity.frame;
        frame.size.height = kOpenedViewHeight;
        frame.size.width = self.scrollView.frame.size.width;
        
        _activity.frame = frame;
        [self addSubview:_activity];
        [_scrollView sendSubviewToBack:self];
        
        _refreshing = NO;
        _ignoreInset = NO;
        
    }
    return self;
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentInset"];
    [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
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
        [self.scrollView removeObserver:self forKeyPath:@"contentSize"];
        self.scrollView = nil;
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentInset"]) {
        if (!_ignoreInset) {
            self.originalContentInset = [[change objectForKey:@"new"] UIEdgeInsetsValue];
        }
        return;
    }
    
    /*if ([keyPath isEqualToString:@"contentSize"]) {
        if (!_ignoreInset) {
            [self placeSubviews];
        }
        return;
    }*/
    
    
    if (!self.enabled  || _refreshing || !self.scrollView.isDragging) {
        return;
    }
    
    //self.originalContentInset = self.scrollView.contentInset;
    
    CGFloat offset = [self getDraggingOffset:self.scrollView.contentOffset.y];
    CGFloat verticalShift = (kMaxTopPadding + kMaxBottomPadding) + offset;
    
    //NSLog(@"class=%@ y=%f bottom=%f offset=%f verticalShift=%f changnewy=%f", [self class], self.scrollView.contentOffset.y, self.scrollView.contentInset.bottom, offset, verticalShift, [[change objectForKey:@"new"] CGPointValue].y);
    if (verticalShift >= kMaxDistance) {
        
        [self beginRefreshing];
    }
    
    
}

- (void)placeSubviews{
}



#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)getDraggingOffset:(CGFloat)y{
    return y;
}

- (void)beginRefreshing
{
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
    
    if (!_refreshing) {
        self.refreshing = YES;
        [(SKPopBasicRefreshView *)_activity startAnimating];
    }
}

- (void)endRefreshing
{
    if (_refreshing) {
        self.refreshing = NO;
        [(SKPopBasicRefreshView *)_activity stopAnimating];
    }
}

@end
