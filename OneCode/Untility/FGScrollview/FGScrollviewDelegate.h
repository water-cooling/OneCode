//
//  FGScrollviewDelegate.h
//  FungusProject
//
//  Created by humengfan on 2018/6/8.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FGScrollPageViewChildVcDelegate <NSObject>

@optional

/**
 * 请注意: 如果你希望所有的子控制器的view的系统生命周期方法被正确的调用
 * 请重写父控制器的'shouldAutomaticallyForwardAppearanceMethods'方法 并且返回NO
 * 当然如果你不做这个操作, 子控制器的生命周期方法将不会被正确的调用
 * 如果你仍然想利用子控制器的生命周期方法, 请使用'ZJScrollPageViewChildVcDelegate'提供的代理方法
 * 或者'ZJScrollPageViewDelegate'提供的代理方法
 */
- (void)zj_viewWillAppearForIndex:(NSInteger)index;
- (void)zj_viewDidAppearForIndex:(NSInteger)index;
- (void)zj_viewWillDisappearForIndex:(NSInteger)index;
- (void)zj_viewDidDisappearForIndex:(NSInteger)index;

- (void)zj_viewDidLoadForIndex:(NSInteger)index;

@end



@protocol FGScrollviewDelegate <NSObject>
/** 将要显示的子页面的总数 */
- (NSInteger)numberOfChildViewControllers;

/** 获取到将要显示的页面的控制器
 * -reuseViewController : 这个是返回给你的controller, 你应该首先判断这个是否为nil, 如果为nil 创建对应的控制器并返回, 如果不为nil直接使用并返回
 * -index : 对应的下标
 */
- (UIViewController<FGScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<FGScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index;

@optional


- (void)setUpTitleView:(UILabel *)label forIndex:(NSInteger)index;


- (BOOL)scrollPageController:(UIViewController *)scrollPageController contentScrollView:(UICollectionView *)scrollView shouldBeginPanGesture:(UIPanGestureRecognizer *)panGesture;


/**
 *  页面将要出现
 *
 *  @param scrollPageController
 *  @param childViewController
 *  @param index
 */
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index;
/**
 *  页面已经出现
 *
 *  @param scrollPageController
 *  @param childViewController
 *  @param index
 */

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index;


- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index;
- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidDisappear:(UIViewController *)childViewController forIndex:(NSInteger)index;
/**
 *  页面添加到父视图时，在父视图中显示的位置
 *  @param  containerView   childController 的 self.view 父视图
 *  @return 返回最终显示的位置
 */
- (CGRect)frameOfChildControllerForContainer:(UIView *)containerView;
@end
