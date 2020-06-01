//
//  ShowStateView.h
//  bihucj
//
//  Created by humengfan on 2018/8/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    StateCenter,
    StateBottom,
} StateType;

@interface ShowStateView : UIView

+ (void)showStateViewTitle:(NSString *)title StateType:(StateType)type autoClear:(BOOL)clear AutoclearClearTimer:(NSTimeInterval)time;
@end
