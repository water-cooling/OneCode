//
//  FGContentView.h
//  FungusProject
//
//  Created by humengfan on 2018/6/8.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGScrollviewDelegate.h"
#import "FGScrollSegmentView.h"
@interface FGContentView : UIView


/** 必须设置代理和实现相关的方法*/
@property(weak, nonatomic)id<FGScrollviewDelegate> delegate;

@property (weak, nonatomic,readonly) FGScrollSegmentView *segmentView;

@property (strong, nonatomic, readonly) UIViewController<FGScrollPageViewChildVcDelegate> *currentChildVc;

@property (strong, nonatomic, readonly) UICollectionView *collectionView;

/**初始化方法
 *
 */
- (instancetype)initWithFrame:(CGRect)frame  segmentView:(FGScrollSegmentView *)segmentView parentViewController:(UIViewController *)parentViewController delegate:(id<FGScrollviewDelegate>) delegate;

/** 给外界可以设置ContentOffSet的方法 */
- (void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;
/** 给外界 重新加载内容的方法 */
- (void)reload;


@end
