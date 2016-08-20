//
//  UIView+SKInfiniteScrollingView.m
//  headTableView
//
//  Created by 魏娟 on 16/8/19.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import "SKInfiniteScrollingView.h"

/*#define kTotalViewHeight    400
#define kOpenedViewHeight   55
#define kMinTopPadding      9
#define kMaxTopPadding      5
#define kMinBottomPadding   4
#define kMaxBottomPadding   6
#define kMaxDistance        140

@interface SKInfiniteScrollingView ()

@property (nonatomic, readwrite) BOOL refreshing;
@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, assign) UIEdgeInsets originalContentInset;

@end

@implementation SKInfiniteScrollingView

@synthesize refreshing = _refreshing;

@synthesize scrollView = _scrollView;
@synthesize originalContentInset = _originalContentInset;


- (id)initInScrollView:(UIScrollView *)scrollView {
    return [self initInScrollView:scrollView activityIndicatorView:nil];
}

- (id)initInScrollView:(UIScrollView *)scrollView activityIndicatorView:(SKPopBasicRefreshView *)activity
{
    self = [super initWithFrame:CGRectMake(0, scrollView.contentSize.height, scrollView.frame.size.width, kOpenedViewHeight)];
    
    if (self) {
        self.scrollView = scrollView;
        self.scrollView.backgroundColor = [UIColor blueColor];
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
            self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, kOpenedViewHeight);
        }
        return;
    }
    
    if ([keyPath isEqualToString:@"contentSize"]) {
            self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, kOpenedViewHeight);
        return;
    }
    
    
    if (!self.enabled  || _refreshing || !self.scrollView.isDragging) {
        return;
    }
    
    CGFloat offset = [self getDraggingOffset:[[change objectForKey:@"new"] CGPointValue].y];
    CGFloat verticalShift = (kMaxTopPadding + kMaxBottomPadding) + offset;
    
    //NSLog(@"y=%f bottom=%f offset=%f verticalShift=%f", self.scrollView.contentOffset.y, self.scrollView.contentInset.bottom, offset, verticalShift);
    if (verticalShift >= kMaxDistance) {
        
        [self beginRefreshing];
    }
    
    
}

#pragma mark - 私有方法
#pragma mark 获得scrollView的内容 超出 view 的高度
- (CGFloat)getDraggingOffset:(CGFloat)y{
    return y - [self happenOffsetY];
}

- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.originalContentInset.bottom - self.originalContentInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.originalContentInset.top;
    } else {
        return - self.originalContentInset.top;
    }
}


- (void)beginRefreshing
{
    if (!_refreshing) {
        self.refreshing = YES;
        CGFloat bottom = self.height + self.originalContentInset.bottom;
        CGFloat deltaH = [self heightForContentBreakView];
        if (deltaH < 0) { // 如果内容高度小于view的高度
            bottom -= deltaH;
        }
        
        __block UIScrollView *blockScrollView = self.scrollView;
        [UIView animateWithDuration:1 animations:^{
            _ignoreInset = YES;
            blockScrollView.insetB = bottom;
            blockScrollView.offsetY = [self happenOffsetY] + self.height;
        } completion:^(BOOL finished) {
            blockScrollView.insetB = bottom;
            blockScrollView.offsetY = [self happenOffsetY] + self.height;
             _activity.center = CGPointMake(floor(self.frame.size.width / 2), floor(self.frame.size.height / 2));
            
            [(SKPopBasicRefreshView *)_activity startAnimating];
            _ignoreInset = NO;
            
            
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

@end*/

@implementation SKInfiniteScrollingView

- (void)placeSubviews{
    self.frame = CGRectMake(0, self.scrollView.contentSize.height, self.scrollView.frame.size.width, kOpenedViewHeight);
    _activity.center = CGPointMake(floor(self.frame.size.width / 2), floor(self.frame.size.height / 2));
}

- (CGFloat)getDraggingOffset:(CGFloat)y{
    if (y <= 0) {
        return 0;
    }
    return y - [self happenOffsetY];
}

- (CGFloat)heightForContentBreakView
{
    CGFloat h = self.scrollView.frame.size.height - self.originalContentInset.bottom - self.originalContentInset.top;
    return self.scrollView.contentSize.height - h;
}

#pragma mark 刚好看到上拉刷新控件时的contentOffset.y
- (CGFloat)happenOffsetY
{
    CGFloat deltaH = [self heightForContentBreakView];
    if (deltaH > 0) {
        return deltaH - self.originalContentInset.top;
    } else {
        return - self.originalContentInset.top;
    }
}

- (void)beginRefreshing
{
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
    if (!_refreshing) {
        self.refreshing = YES;
        CGFloat bottom = self.height + self.originalContentInset.bottom;
        CGFloat deltaH = [self heightForContentBreakView];
        if (deltaH < 0) { // 如果内容高度小于view的高度
            bottom -= deltaH;
        }
        
        __block UIScrollView *blockScrollView = self.scrollView;
        [UIView animateWithDuration:1 animations:^{
            _ignoreInset = YES;
            blockScrollView.insetB = bottom;
            blockScrollView.offsetY = [self happenOffsetY] + self.height;
        } completion:^(BOOL finished) {
            blockScrollView.insetB = bottom;
            blockScrollView.offsetY = [self happenOffsetY] + self.height;
            
            [self placeSubviews];
            [(SKPopBasicRefreshView *)_activity startAnimating];
            _ignoreInset = NO;
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
        } completion:^(BOOL finished) {
            [blockScrollView setContentInset:self.originalContentInset];
            [(SKPopBasicRefreshView *)_activity stopAnimating];
            _ignoreInset = NO;
            
        }];
    }
}

@end

