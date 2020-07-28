//
//  BaseNavigationController.m
//  AnTaiProperty
//
//  Created by lihaibo on 16/5/26.
//  Copyright © 2016年 xitai. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property(nonatomic,strong) UIViewController* currentShowVC;
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
    if (@available(iOS 13.0, *)) {
        self.modalPresentationStyle = UIModalPresentationFullScreen;
    }
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}
-(void)viewDidLayoutSubviews{
    [self.navigationBar KPHideShadowImagebackImageColor:themeColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (navigationController.viewControllers.count == 1) {
        self.currentShowVC = Nil;
    } else {
        self.currentShowVC = viewController;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        return (self.currentShowVC == self.topViewController); //the most important
    }
    return YES;
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    //全部修改返回按钮,但是会失去右滑返回的手势
    if (viewController.navigationItem.leftBarButtonItem ==nil && self.viewControllers.count >=1) {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [self setFakeNavigationBarCommonLeftButton];

        [super pushViewController:viewController animated:animated];
    }
}
-(UIBarButtonItem *)setFakeNavigationBarCommonLeftButton{
    UIBarButtonItem *backItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backItemAction)];
    backItem.tintColor = [UIColor whiteColor];
    return backItem;
}
-(void)backItemAction{
    [self popViewControllerAnimated:YES];
}
@end
