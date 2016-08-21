//
//  UIView+Common.h
//  headTableView
//
//  Created by 魏娟 on 16/8/18.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKPopRefreshView.h"

@interface UIView (Common)

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGSize  size;
@property (assign, nonatomic) CGPoint origin;
@end

@interface UIScrollView (Common)
@property (assign, nonatomic) CGFloat insetB;
@property (assign, nonatomic) CGFloat insetT;
@property (assign, nonatomic) CGFloat offsetY;
@end

