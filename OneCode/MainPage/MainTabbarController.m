//
//  MainTabbarController.m
//  bihucj
//
//  Created by humengfan on 2018/7/17.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "MainTabbarController.h"
#import "BaseNavigationController.h"
#import "UserUtility.h"
@interface MainTabbarController ()<UITabBarControllerDelegate>

@end

@implementation MainTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self setSelectedIndex:1];

    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#666666"];
    
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrSelected[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#1A1A1A"];
    
    UITabBarItem *item = [UITabBarItem appearance];

    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:attrSelected forState:UIControlStateSelected];
    
    self.delegate = self;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Loginout) name:LoginOut object:nil];



    // Do any additional setup after loading the view.
}

-(void)Loginout{
    
    [self setSelectedIndex:1];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    BaseNavigationController *vc = [story instantiateViewControllerWithIdentifier:@"BaseNavigationController"];
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    
    if (![viewController.tabBarItem.title isEqualToString:@"我的"]) {
        
        return YES;
        
    }
    
  
if ([UserUtility hasLogin]) {
        
        return YES;
    
}
    
    
UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

BaseNavigationController *vc = [story instantiateViewControllerWithIdentifier:@"BaseNavigationController"];

[self presentViewController:vc animated:YES completion:nil];

    return NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
