//
//  BaseViewController.m
//  MBCA
//
//  Created by boyce.huang on 2017/8/22.
//  Copyright © 2017年 huangpf. All rights reserved.
//

#import "BaseViewController.h"
//#import "IPChangedInfoViewController.h"
@interface BaseViewController ()
@property(nonatomic,strong)UIView * bgView;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets = false;
    
    NSString *version= [UIDevice currentDevice].systemVersion;
    if(version.doubleValue >=13.0) {
        // 针对13.0 以上的iOS系统进行处理
        [self setOverrideUserInterfaceStyle:UIUserInterfaceStyleLight];
    }
    [self.navigationController.navigationBar setBackgroundImage:[Common setBGImageSize:CGSizeMake(SCREENWIDTH, 64) fromColor:RGBColor(0xf1a10e, 1) toColor:RGBColor(0xff7e28, 1)] forBarMetrics:UIBarMetricsDefault];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
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
    [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回箭头"]
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
        footer.stateLabel.font = [UIFont systemFontOfSize:15.0 weight:FONT_WEIGHT_THIN];
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

-(void)addLoginBottomLbl{
    MJWeakSelf;
    UILabel * bottomImg = [[UILabel alloc]init];
    bottomImg.textColor = RGBColor(0x080808, 1);
    bottomImg.font= kFont(12);
    bottomImg.text = @"©2017 FIS. Empowering the Financial World ™";
    [self.view addSubview:bottomImg];
    [bottomImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-35);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
}

-(void)pushLogin{
}

-(void)turnToLogin{
    LoginViewController *login = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:login];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
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

-(UIView *)noNetOrNodataNewView:(NSInteger)flag tableViewFrame:(CGRect)frame{
    _bgView = [[UIView alloc]initWithFrame:frame];
    UIImageView * img = [[UIImageView alloc]init];
    [_bgView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView.mas_centerX);
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.height.mas_equalTo(144);
        make.width.mas_equalTo(152.5);
    }];
    if (flag == 0) {
        img.image = [UIImage imageNamed:@"升级提示"];
    }else{
        img.image = [UIImage imageNamed:@"升级提示"];
    }
    return _bgView;
}

-(void)setIOS:(UIScrollView *)scroller{
    if (@available(iOS 11.0, *)) {
        scroller.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)turnToOrderDetail:(NSInteger)type detailRowId:(NSString *)detailRowId vctype:(NSString *)vcType{
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc]initWithCapacity:0];
    switch (type) {
        case 0:{
            [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
            [parameter setObject:@"NewHomePageViewController" forKey:@"vcType"];
            [Common pushUrl:@"FillOilOrderDetailViewController" withTarget:self withParamer:parameter];
        }
            break;
        case 1:{
            [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
            [parameter setObject:@"ActivityViewController" forKey:@"vcType"];
            [Common pushUrl:@"RechargeableCardDetailViewController" withTarget:self withParamer:parameter];
        }
            break;
        case 2:{
            [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
            [parameter setObject:@"MyWebViewController" forKey:@"vcType"];
            [Common pushUrl:@"FillOilCardOrderDetailViewController" withTarget:self withParamer:parameter];
        }
            break;
        case 3:{
            [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
            [parameter setObject:vcType forKey:@"vcType"];
            [Common pushUrl:@"ProductOrderDetailViewController" withTarget:self withParamer:parameter];
        }
            break;
        case 4:{
            //蓄油卡
            [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
            [parameter setObject:vcType forKey:@"vcType"];
            [Common pushUrl:@"StorageOilOrderDetailViewController" withTarget:self withParamer:parameter];
        }
            break;
        case 5:{
            //储值卡
            [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
            [parameter setObject:vcType forKey:@"vcType"];
            [Common pushUrl:@"StoredCardOrderDetailViewController" withTarget:self withParamer:parameter];
        }
            break;
            
        case 7:{
            //开发票
            [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
            [parameter setObject:@"OpenInvoiceListViewController" forKey:@"vcType"];
            [Common pushUrl:@"InvoiceOrderDetailViewController" withTarget:self withParamer:parameter];
            
        }
            break;
            
        default:
            break;
    }
    
}

///  0:加油 1:充值卡 2:加油卡 3:商品 4:油品贸易  5:储值卡 6.提现
-(void)turnCompletionVc:(NSInteger)type detailRowId:(NSString *)detailRowId vctype:(NSString *)vcType payAmt:(NSString *)payAmt orderCode:(NSString *)orderCode{
    
    NSMutableDictionary * parameter = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [parameter setObject:detailRowId?detailRowId:@"" forKey:@"rowId"];
    [parameter setObject:payAmt?payAmt:@"" forKey:@"payMoney"];
    [parameter setObject:orderCode forKey:@"orderCode"];
    [parameter setObject:vcType forKey:@"vcType"];
    switch (type) {
        case 0:
        {
            [parameter setObject:@"2" forKey:@"orderType"];
        }
            break;
        case 1:
        {
            [parameter setObject:@"1" forKey:@"orderType"];
        }
            break;
        case 2:{
            [parameter setObject:@"0" forKey:@"orderType"];
            [Common pushUrl:@"OilCardPayCompleteViewController" withTarget:self withParamer:parameter];
            return;
        }
            break;
        case 3:{
            //商品
            [parameter setObject:@"3" forKey:@"orderType"];
        }
            break;
        case 4:{
            [parameter setObject:@"4" forKey:@"orderType"];
            [Common pushUrl:@"OrderCompleteViewController" withTarget:self withParamer:parameter];
            return;
        }
            break;
        case 5:{
            [parameter setObject:@"5" forKey:@"orderType"];
        }
            break;
            
        case 7:{
            [parameter setObject:@"7" forKey:@"orderType"];
        }
            break;
            
        default:
            break;
    }
    [Common pushUrl:@"OrderCompleteViewController" withTarget:self withParamer:parameter];
}

@end
