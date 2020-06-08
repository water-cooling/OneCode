//
//  BaseViewController.m
//  MBCA
//
//  Created by boyce.huang on 2017/8/22.
//  Copyright © 2017年 huangpf. All rights reserved.
//

#import "BaseViewController.h"
#import "UINavigationBar+BackImageView.h"
#import <MJRefresh/MJRefresh.h>
#import "LoginViewController.h"
//#import "IPChangedInfoViewController.h"
@interface BaseViewController ()<UINavigationControllerDelegate>
@property(nonatomic,strong)UIView * bgView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = false;
    self.navigationController.delegate = self;
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue >=13.0) {
        // 针对13.0 以上的iOS系统进行处理
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    }
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)setFakeNavigationBarRightButton:(UIButton*)rightButton{
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)setFakeNavigationBarLeftButton:(UIButton *)leftButton{
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
}

-(void)setFakeNavigationBarCommonLeftButton{
    
    UIBarButtonItem *backItem =
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"]
                                     style:UIBarButtonItemStylePlain
                                    target:self
                                    action:@selector(backItemAction)];
    backItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backItem;
}

-(void)setFakeNavigationBarLeftView:(UIView *)leftView{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftbtnAction)];
    [leftView addGestureRecognizer:tap];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:leftView];
    self.navigationItem.leftBarButtonItem = item;
}

-(void)leftbtnAction{
}

-(void)setFakeNavigationBarRightView:(UIView *)RightView{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightBtnAction)];
    [RightView addGestureRecognizer:tap];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:RightView];
    self.navigationItem.rightBarButtonItem = item;
}

-(void)rightBtnAction{
}

-(void)backItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setFakeNavigationBarTitleView:(UIView *)titleView{
    self.navigationItem.titleView=titleView;
}

-(void)changeNVColor:(UIColor *)color{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.backgroundColor = color;
     self.navigationController.navigationBar.barTintColor = color;
}

//设置下拉刷新项
-(void)setupRefreshTable:(UIScrollView *)tableView needsFooterRefresh:(BOOL)isFooterRefresh{
    if (tableView == nil) {
        return;
    }
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reloadHeaderTableViewDataSource)];
    // 隐藏时间
    //    header.lastUpdatedTimeLabel.hidden = YES;
    // 隐藏状态
    header.stateLabel.hidden = NO;
    // 马上进入刷新状态
    // 设置header
    tableView.mj_header = header;
    if (isFooterRefresh) {
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        // 设置字体
        footer.stateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightThin];
        [footer setTitle:@"" forState:MJRefreshStateIdle];
        // 设置颜色
        footer.stateLabel.textColor = [UIColor blackColor];
        tableView.mj_footer = footer;
        tableView.mj_footer.automaticallyHidden = YES;
    }
}
-(void)reloadHeaderTableViewDataSource{
}

- (void)reloadFooterTableViewDataSource{
}

-(void) loadMoreData{
    [self reloadFooterTableViewDataSource];
}

-(void)pushLogin{
}

-(void)turnToLogin{
    BaseNavigationController *loginNavi = [self.storyboard instantiateViewControllerWithIdentifier:@"BaseNavigationController"];
    loginNavi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self.navigationController presentViewController:loginNavi animated:YES completion:nil];
}

-(UIView *)noNetOrNodataView:(NSInteger)flag tableViewFrame:(CGRect)frame{
     _bgView = [[UIView alloc]initWithFrame:frame];
    UIImageView * img = [[UIImageView alloc]init];
    [_bgView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bgView.mas_centerX);
        make.centerY.equalTo(_bgView.mas_centerY);
        make.height.mas_equalTo(144);
        make.width.mas_equalTo(152.5);
    }];
    if (flag == 0) {
        img.image = [UIImage imageNamed:@"暂无"];
        self.view.backgroundColor = [UIColor whiteColor];
    }else{
        img.image = [UIImage imageNamed:@"暂无数据"];
    }
    return _bgView;
}

-(void)setIOS:(UIScrollView *)scroller{
    if (@available(iOS 11.0, *)) {
        scroller.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}


@end
