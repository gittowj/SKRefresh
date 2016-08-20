//
//  NSString+PopRefreshView.h
//  headTableView
//
//  Created by 魏娟 on 16/8/18.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SKPopBasicRefreshView : UIView

- (void)startAnimating;
- (void)stopAnimating;
@end

@interface SKPopRefreshView : SKPopBasicRefreshView

@end
