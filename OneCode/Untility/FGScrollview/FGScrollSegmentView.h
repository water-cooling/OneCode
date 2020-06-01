//
//  FGScrollSegmentView.h
//  FungusProject
//
//  Created by humengfan on 2018/6/8.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGScrollviewDelegate.h"

typedef void(^TitleBtnOnClickBlock)(NSString *Str, NSInteger index);

@interface FGScrollSegmentView : UIView

@property (weak, nonatomic) id<FGScrollviewDelegate> delegate;
-(instancetype)initWithFrame:(CGRect)frame WithTitleArr:(NSArray *)Arr delegate:(id<FGScrollviewDelegate>)delegate titleDidClick:(TitleBtnOnClickBlock)titleDidClick;

- (void)adjustUIWithProgress:(CGFloat)progress oldIndex:(NSInteger)oldIndex currentIndex:(NSInteger)currentIndex;
/** 让选中的标题居中*/
- (void)adjustTitleOffSetToCurrentIndex:(NSInteger)currentIndex;
/** 设置选中的下标*/
@end
