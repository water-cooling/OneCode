//
//  ShowStateView.m
//  bihucj
//
//  Created by humengfan on 2018/8/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "ShowStateView.h"
#import "AppDelegate.h"
#import <MBProgressHUD.h>

@implementation ShowStateView

+ (void)showStateViewTitle:(NSString *)title StateType:(StateType)type autoClear:(BOOL)clear AutoclearClearTimer:(NSTimeInterval)time{
    
    
    UIWindow * window = [UIWindow new];
    
    window.backgroundColor = [UIColor clearColor];
    
    window.windowLevel = UIWindowLevelAlert;
    
    window.hidden = NO;

    CGRect frame = CGRectMake( 0, 0 , 175, 30);
    
    window.frame = frame;

    ShowStateView * showView= [[ShowStateView alloc]initWithFrame:frame StateViewTitle:title StateType:type];
    
    showView.backgroundColor = [UIColor clearColor];
    
    showView.alpha = 0.0;
    
    
    UIWindow *keywindow = [[UIApplication sharedApplication] keyWindow];
    
    if (type == StateCenter) {
        
        window.center = keywindow.center;
    }else
    {
        
        window.center = CGPointMake(keywindow.center.x, keywindow.center.y + UISCREENHEIGHT/2 - 90);

    }
    
    
    [window addSubview: showView];
    
    [keywindow addSubview:window];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        showView.alpha = 1;
    }];
    
    if (clear) {
        
        [self performSelector:@selector(hideNotice:) withObject:window afterDelay:time];
    }

}


+(void)hideNotice:(UIWindow *) sender  {
    
if ([sender isKindOfClass:[UIWindow class]]) {
        
    UIView * firstView = sender.subviews.firstObject;
        
        [UIView animateWithDuration:0.2 animations:^{
            
            firstView.frame =  CGRectMake(0, -firstView.height,firstView.width , firstView.height);
            
            firstView.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            
            [sender removeFromSuperview];

        }];
    }
}
-(instancetype)initWithFrame:(CGRect)frame StateViewTitle:(NSString *)title  StateType:(StateType)type
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        
        [self addSubview:label];
        
        label.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        
        label.layer.cornerRadius =  15;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.layer.masksToBounds =  YES;
        
        label.text = title;
        
        if (type == StateCenter) {
            
            label.textColor = titleColor;
            
            label.backgroundColor = buttonSelectBackgroundColor;
        }else
        {
            label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
            
            label.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.3];
            
        }
        
    }
    
    return self;
    
}



@end
