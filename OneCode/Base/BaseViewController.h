//
//  BaseViewController.h
//  MBCA
//
//  Created by boyce.huang on 2017/8/22.
//  Copyright © 2017年 huangpf. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CommonViewController.h"

@interface BaseViewController : UIViewController
- (void)setFakeNavigationBarRightButton:(UIButton *)rightButton;
- (void)setFakeNavigationBarLeftButton:(UIButton *)leftButton;
- (void)setFakeNavigationBarLeftView:(UIView *)leftView;
- (void)setFakeNavigationBarRightView:(UIView *)RightView;
- (void)setFakeNavigationBarTitleView:(UIView *)titleView;
- (void)setFakeNavigationBarCommonLeftButton;


- (void)setupRefreshTable:(UIScrollView *)tableView needsFooterRefresh:(BOOL)isFooterRefresh;
- (void)reloadHeaderTableViewDataSource;
- (void)reloadFooterTableViewDataSource;

- (void)addLoginBottomLbl;
- (void)leftbtnAction;
- (void)rightBtnAction;
- (void)backItemAction;

-(void)turnCompletionVc:(NSInteger)type detailRowId:(NSString *)detailRowId vctype:(NSString *)vcType payAmt:(NSString *)payAmt orderCode:(NSString *)orderCode;
-(void)turnToOrderDetail:(NSInteger)type detailRowId:(NSString *)detailRowId vctype:(NSString *)vcType;

- (void)turnToLogin;
-(void)pushLogin;

-(UIView *)noNetOrNodataView:(NSInteger)flag tableViewFrame:(CGRect)frame;
-(UIView *)noNetOrNodataNewView:(NSInteger)flag tableViewFrame:(CGRect)frame;

- (void)changeNVColor:(UIColor *)color;
-(void)setIOS:(UIScrollView *)scroller;
@end
