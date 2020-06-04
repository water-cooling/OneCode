//
//  UINavigationController+BackImageView.m
//  FungusProject
//
//  Created by humengfan on 2018/6/26.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "UINavigationBar+BackImageView.h"
#import <objc/runtime.h>
static const NSString * overlayKey = @"key";

@implementation UINavigationBar (BackImageView)

- (UIView *)overlay
{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView  *)overlay
{
    objc_setAssociatedObject(self, &overlayKey, overlay, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)KPSetBackground
{
    if (!self.overlay) {
        
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        UIView *backgroundView = [self KPGetBackgroundView];
        
        self.overlay = [[UIView alloc] initWithFrame:backgroundView.bounds];
        
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        
        [backgroundView insertSubview:self.overlay atIndex:0];
    }
}

- (UIView*)KPGetBackgroundView
{
    //iOS10之前为 _UINavigationBarBackground, iOS10为 _UIBarBackground
    //_UINavigationBarBackground实际为UIImageView子类，而_UIBarBackground是UIView子类
    //之前setBackgroundImage直接赋值给_UINavigationBarBackground，现在则是设置后为_UIBarBackground增加一个UIImageView子控件方式去呈现图片
    
    if ([phoneVersion floatValue] >= 10.0) {
        UIView *_UIBackground;
        NSString *targetName = @"_UIBarBackground";
        Class _UIBarBackgroundClass = NSClassFromString(targetName);
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UIBarBackgroundClass.class]) {
                _UIBackground = subview;
                break;
            }
        }
        return _UIBackground;
    }
    else {
        UIView *_UINavigationBarBackground;
        NSString *targetName = @"_UINavigationBarBackground";
        Class _UINavigationBarBackgroundClass = NSClassFromString(targetName);
        
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:_UINavigationBarBackgroundClass.class]) {
                _UINavigationBarBackground = subview;
                break;
            }
        }
        return _UINavigationBarBackground;
    }
}

#pragma mark - shadow view
- (void)KPHideShadowImagebackImageColor:(UIColor *)color
{
    [self KPSetBackground];
 
    self.overlay.backgroundColor = color;
}

- (void)KPAlphaShadowImagebackImage:(CGFloat)Alpha
{
    
    self.overlay.alpha = Alpha;
}


@end
