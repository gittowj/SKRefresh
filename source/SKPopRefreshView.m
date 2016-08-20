//
//  NSString+PopRefreshView.m
//  headTableView
//
//  Created by 魏娟 on 16/8/18.
//  Copyright © 2016年 魏娟. All rights reserved.
//

#import "SKPopRefreshView.h"
#import <pop/POP.h>


@implementation SKPopBasicRefreshView

@end

@interface SKPopRefreshView ()<POPAnimationDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) BOOL isLoading;
@end

#define menuButtonWidth 10
#define menuButtonHeight 10
#define MenuButtonVerticalPadding 7
#define MenuButtonHorizontalMargin 7
#define MenuButtonAnimationTime 0.5
#define MenuButtonAnimationInterval (MenuButtonAnimationTime / 5)

@implementation SKPopRefreshView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _isLoading = NO;
        UIView *layer1 = [UIView new];
        layer1.backgroundColor = [SKPopRefreshView colorWithHexString:@"ff6f2d"];
        layer1.layer.cornerRadius = 5;
        [self addSubview:layer1];
        
        
        UIView *layer2 = [UIView new];
        layer2.backgroundColor = [SKPopRefreshView colorWithHexString:@"ff5717"];
        layer2.layer.cornerRadius = 5;
        [self addSubview:layer2];
        
        UIView *layer3 = [UIView new];
        layer3.backgroundColor = [SKPopRefreshView colorWithHexString:@"f04d24"];
        
        layer3.layer.cornerRadius = 5;
        [self addSubview:layer3];
        
        UIView *layer4 = [UIView new];
        layer4.backgroundColor = [SKPopRefreshView colorWithHexString:@"d23927"];
        layer4.layer.cornerRadius = 5;
        [self addSubview:layer4];
        
        UIView *layer5 = [UIView new];
        layer5.backgroundColor = [SKPopRefreshView colorWithHexString:@"c32f29"];
        layer5.layer.cornerRadius = 5;
        [self addSubview:layer5];
        
        self.items = [[NSMutableArray alloc] init];
        [self.items addObject:layer1];
        [self.items addObject:layer2];
        [self.items addObject:layer3];
        [self.items addObject:layer4];
        [self.items addObject:layer5];
    }
    
    return self;
}

- (void)showButton:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    for (int index = 0; index < self.items.count; index++) {
        UIView *alayer = self.items[index];
        
        CGRect toRect = [self getFrameWidthItmeCount:self.items.count itemWidth:menuButtonWidth itemHeight:menuButtonHeight paddingX:MenuButtonVerticalPadding paddingY:0 atIndex:index];
        
        CGRect fromRect = toRect;
        
        fromRect.origin.y += startPoint.y;
        toRect.origin.y += endPoint.y;
        
        alayer.frame = fromRect;
        
        double delayInSeconds = index * MenuButtonAnimationInterval;
        NSString *animationKey = @"POPSpringAnimationKey";
        
        [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:alayer beginTime:delayInSeconds animationKey:(NSString *)animationKey];
    }
    
}

- (void)hiddenButton:(CGPoint)startPoint endPoint:(CGPoint)endPoint{
    for (int index = 0; index < self.items.count; index++) {
        UIView *alayer = self.items[index];
        
        CGRect toRect = [self getFrameWidthItmeCount:self.items.count itemWidth:menuButtonWidth itemHeight:menuButtonHeight paddingX:MenuButtonVerticalPadding paddingY:0 atIndex:index];
        
        CGRect fromRect = toRect;
        
        fromRect.origin.y += startPoint.y;
        toRect.origin.y += endPoint.y;
        
        alayer.frame = fromRect;
        
        double delayInSeconds = index * MenuButtonAnimationInterval;
        NSString *animationKey = @"StopPOPSpringAnimationKey";
        
        [self initailzerAnimationWithToPostion:toRect formPostion:fromRect atView:alayer beginTime:0.5 animationKey:(NSString *)animationKey];
    }

}

- (CGRect)getFrameWidthItmeCount:(NSInteger)itemCount itemWidth:(CGFloat)itemWidth itemHeight:(CGFloat)itemHeight paddingX:(CGFloat)paddingX paddingY:(CGFloat)paddingY atIndex:(NSInteger)index{
    
    CGFloat orignY = (CGRectGetHeight(self.bounds) - (itemHeight + paddingY)) / 2.0;
    CGFloat orignX = (CGRectGetWidth(self.bounds) /2- ((itemWidth+paddingX)*itemCount-paddingX) / 2.0 - paddingX)+ ((index + 1) * (itemWidth + paddingX));
    
    return CGRectMake(orignX, orignY, itemWidth, itemHeight);
}

#pragma mark - Animation

- (void)initailzerAnimationWithToPostion:(CGRect)toRect formPostion:(CGRect)fromRect atView:(CALayer *)view beginTime:(CFTimeInterval)beginTime animationKey:(NSString *)animationKey{
    
    POPSpringAnimation *springAnimation = [POPSpringAnimation animation];
    springAnimation.delegate = self;
    springAnimation.name = animationKey;
    springAnimation.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    springAnimation.removedOnCompletion = YES;
    springAnimation.beginTime = beginTime + CACurrentMediaTime();
    CGFloat springBounciness = 10 - beginTime * 2;
    springAnimation.springBounciness = springBounciness;    // value between 0-20
    
    CGFloat springSpeed = 12 - beginTime * 2;
    springAnimation.springSpeed = springSpeed;     // value between 0-20
    springAnimation.toValue = [NSValue valueWithCGRect:toRect];
    springAnimation.fromValue = [NSValue valueWithCGRect:fromRect];
    
    [view pop_addAnimation:springAnimation forKey:animationKey];
}

- (void)pop_animationDidStop:(POPAnimation *)anim finished:(BOOL)finished{
    if (finished && anim.name == @"POPSpringAnimationKey") {
        for (int index = 0; index < self.items.count; index++) {
            UIView *alayer = self.items[index];
            
            CGRect toRect = [self getFrameWidthItmeCount:self.items.count itemWidth:menuButtonWidth itemHeight:menuButtonHeight paddingX:MenuButtonVerticalPadding paddingY:0 atIndex:index];
            CGRect frame = alayer.frame;
            
            CGFloat from_x = frame.origin.x;
            CGFloat to_x = toRect.origin.x;
            if (frame.origin.x != toRect.origin.x || frame.origin.y != toRect.origin.y){
                return;
            }
        }
        
        
        
        for (int index = 0; index < self.items.count; index++) {
            UIView *alayer = self.items[index];
            
            CGRect toRect = [self getFrameWidthItmeCount:self.items.count itemWidth:menuButtonWidth itemHeight:menuButtonHeight paddingX:MenuButtonVerticalPadding paddingY:0 atIndex:index];
            double delayInSeconds = index * MenuButtonAnimationInterval;
            
            
            [self loadingAnimation:toRect atView:alayer beginTime:delayInSeconds];
            
        }
        
        
    }
}

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert {
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [SKPopRefreshView colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

- (void)startAnimating{
    self.alpha = 1;
    if (_isLoading) {
        return;
    }
    _isLoading = YES;
    [self showButton:CGPointMake(0, -50) endPoint:CGPointMake(0, 0)];
    
}

- (void)stopAnimating{
    _isLoading = NO;
    
    for (int index = 0; index < self.items.count; index++) {
        UIView *alayer = self.items[index];
        [alayer.layer removeAllAnimations];
    }
    
    //[self hiddenButton:CGPointMake(0, 0) endPoint:CGPointMake(0, -30)];
    self.alpha = 0;
}

- (void)loadingAnimation:(CGRect)fromRect atView:(UIView *)view beginTime:(CFTimeInterval)beginTime{
    
    __weak typeof(UIView *) weaklayer = view;
    [UIView animateKeyframesWithDuration:0.1 delay:beginTime options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        weaklayer.alpha = 0.3;
        
        CGRect frame = fromRect;
        frame.origin.y += 10;
        weaklayer.frame = frame;
        
    } completion:^(BOOL finished) {
        
        CGRect frame = fromRect;
        frame.origin.y += 10;
        weaklayer.frame = frame;
        weaklayer.alpha = 0.3;
        
        [UIView animateKeyframesWithDuration:0.3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
            
            CGRect frame = fromRect;
            frame.origin.y -= 10;
            weaklayer.frame = frame;
            weaklayer.alpha = 1;
            
        } completion:^(BOOL finished) {
            CGRect frame = fromRect;
            frame.origin.y -= 10;
            weaklayer.frame = frame;
            weaklayer.alpha = 1;
            
            [UIView animateKeyframesWithDuration:0.2 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
                
                CGRect frame = fromRect;
                weaklayer.frame = frame;
                weaklayer.alpha = 1;
                
            } completion:^(BOOL finished) {
                CGRect frame = fromRect;
                weaklayer.frame = frame;
                weaklayer.alpha = 1;
                
                if (self.isLoading) {
                    [self loadingAnimation:fromRect  atView:weaklayer beginTime:1];
                }
            }];
        }];
    }];

}

@end
