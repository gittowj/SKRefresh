//
//  UIView+Common.m
//  headTableView
//
//  Created by 魏娟 on 16/8/18.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import "UIView+Common.h"

@implementation UIView (Common)
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)Width:(CGFloat)w
{
    CGRect frame = self.frame;
    frame.size.width = w;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)h
{
    CGRect frame = self.frame;
    frame.size.height = h;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}


@end

@implementation UIScrollView (Common)

- (void)setInsetB:(CGFloat)insetB
{
    UIEdgeInsets inset = self.contentInset;
    inset.bottom = insetB;
    self.contentInset = inset;
}

- (CGFloat)insetB
{
    return self.contentInset.bottom;
}

- (void)setInsetT:(CGFloat)insetT
{
    UIEdgeInsets inset = self.contentInset;
    inset.top = insetT;
    self.contentInset = inset;
}

- (CGFloat)insetT
{
    return self.contentInset.top;
}

- (void)setOffsetY:(CGFloat)offsetY
{
    CGPoint offset = self.contentOffset;
    offset.y = offsetY;
    self.contentOffset = offset;
}

- (CGFloat)offsetY
{
    return self.contentOffset.y;
}

@end
