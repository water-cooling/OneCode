//
//  HomeNewsController.m
//  bihucj
//
//  Created by humengfan on 2018/7/17.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "HomeNewsController.h"
#import <SDCycleScrollView.h>
#import "HomeNewsCell.h"
#import <MJRefresh.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomeUntility.h"
#import "WebViewController.h"
#import "FGNavigationViewController.h"
#import "UserUtility.h"
@interface HomeNewsController ()<SDCycleScrollViewDelegate>
@property(nonatomic,strong) HomeNewsResponseModel * response;
@property(nonatomic,assign)NSInteger DownIndex;
@property(nonatomic,strong) SDCycleScrollView * BannerView;

@end

@implementation HomeNewsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seachStr = @"";
    self.view.backgroundColor = [UIColor whiteColor ];
    self.BannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 180)];
    self.BannerView.backgroundColor = [UIColor whiteColor];
    self.BannerView.autoScrollTimeInterval = 5.;// 自动滚动时间间隔
    self.BannerView.delegate = self;
    self.BannerView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;// 翻页
    self.BannerView.pageControlDotSize = CGSizeMake(14, 14);
    self.BannerView.currentPageDotColor = buttonSelectBackgroundColor;
    self.BannerView.pageDotColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    UIView  *view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 190)];
    
    
    view.clipsToBounds = YES;
    view.backgroundColor = BackgroundColor;
    
    [view addSubview:self.BannerView];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeNewsCell" bundle:nil] forCellReuseIdentifier:@"HomeNewsCell"];
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.tableHeaderView = view;
    
    self.tableView.tableFooterView = [UIView new];
    
    __weak typeof(self) weakself = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.DownIndex = 1;
        
        [weakself.tableView.mj_footer resetNoMoreData];
        
        [weakself loadingHomeNewsDataLoc:self.DownIndex count:10 tTitleLike:self.seachStr SelectIndex:self.SelectIndex refresh:YES];

    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.DownIndex +=1;
        weakself.tableView.mj_footer.hidden = NO;
        
        [weakself loadingHomeNewsDataLoc:weakself.DownIndex count:10 tTitleLike:weakself.seachStr SelectIndex:self.SelectIndex refresh:NO];
    }];
}

- (void)SeachContent:(NSString *)Str
{
    self.seachStr = Str;
    
    [self loadingHomeNewsDataLoc:self.DownIndex count:10 tTitleLike:self.seachStr SelectIndex:self.SelectIndex refresh:YES];
}

- (void)zj_viewWillAppearForIndex:(NSInteger)index

{
        self.DownIndex = 1;
        
        [self.tableView.mj_footer resetNoMoreData];
    
    self.seachStr = @"";
    
    [self loadingHomeNewsDataLoc:self.DownIndex count:10 tTitleLike:self.seachStr SelectIndex:self.SelectIndex refresh:YES];

}

-(void)loadingHomeNewsDataLoc:(NSInteger)Loc count:(NSInteger)count tTitleLike:(NSString * )Str SelectIndex:(NSInteger)index refresh:(BOOL)isdown{
    
    BOOL Adv ;
    
    if (index == 0 || index == 3) {
        
        Adv = NO;
        
    }else
    {
        Adv = YES;
        
    }
    NSLog(@"我们搜索的字符串是%@",Str);
    [HomeUntility GetHomeNewshasAdv:!Adv pageNo:Loc pageSize:count tTitleLike:Str SelectIndex:index callback:^(HomeNewsResponseModel * Response, FGError * error) {
    
       
        if (isdown) {
            
            [self.tableView.mj_header endRefreshing];
            
            if (Response.rows.count == 0) {
                
                [MBManager showBriefAlert:@"暂无数据"];
            }
            
        }else
        {
            if (Response.rows.count == 0) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                return ;
            }
            [self.tableView.mj_footer endRefreshing];
        }
        if (!error) {
            
            if (isdown) {
                
                self.response = Response;
                
            }else
            {
                [self.response.rows addObjectsFromArray:Response.rows];
                
            }
            
            if (!Adv) {
                
                NSMutableArray * Arr = [NSMutableArray array];
                
                for (BannerModel * model in Response.advRows) {
                    
                    [Arr addObject:model.imgUrl];
                }
                self.BannerView.localizationImageNamesGroup = Arr.copy;
                
                self.tableView.tableHeaderView.height = 190;
                
            }else
            {
                
                self.tableView.tableHeaderView.height = 0;

                
            }
         
            
            [self.tableView reloadData];
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
        }
        
        
    }];
        
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return self.response ? self.response.rows.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeNewsCell" forIndexPath:indexPath];
    
    HomeNewsModel * model = self.response.rows[indexPath.row];
    
    [cell.RightIcon sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage new] options:SDWebImageLowPriority];
    
    cell.TitleLab.text = model.tTitle;
    
cell.TimeLab.text = [NSString stringWithFormat:@"%@ %ld %@",model.cFrom,(long)model.tDjcs,model.processDate];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (![UserUtility hasLogin]) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        FGNavigationViewController *vc = [story instantiateViewControllerWithIdentifier:@"FGNavigationViewController"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
    
    
    HomeNewsModel * model = self.response.rows[indexPath.row];

    [HomeUntility NewsLick:model.ID callback:^(SucceedModel *success, FGError *error) {
       
        if (!error) {
            
            model.tDjcs +=1;
            
            [self.tableView reloadData];
            
            WebViewController * web = [[WebViewController alloc]init];
            
            web.Adv = NO;

            web.linkStr = model.detailH5;
            
            web.sharetilte = model.tTitle;
            


            switch (self.SelectIndex) {
                case 0:
                    web.title = @"新闻详情";
                    break;
                    
                case 1:
                    web.title = @"号外详情";
                    break;
                case 2:
                    web.title = @"行情详情";
                    
                    break;
                case 3:
                    web.title = @"币虎详情";
                    
                    break;
                    
                case 4:
                    web.title = @"政策详情";
                    
                    break;
                    
                default:
                    break;
            }
            
            web.hidesBottomBarWhenPushed = YES;
            
            [self.navigationController pushViewController:web animated:YES];
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
        }
        
        
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return 105;
}




#pragma mark bannerDelelgate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
    
    if (![UserUtility hasLogin]) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        FGNavigationViewController *vc = [story instantiateViewControllerWithIdentifier:@"FGNavigationViewController"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
    
    WebViewController * web = [[WebViewController alloc]init];
    
    
    switch (self.SelectIndex) {
        case 0:
            web.title = @"资讯详情";
            break;
        case 1:
            web.title = @"号外详情";
            
            break;
        case 2:
            web.title = @"行情详情";
            
            break;
            
        case 3:
            web.title = @"币虎专栏详情";
            
            break;
            
        case 4:
            web.title = @"政策详情";
            
            break;
            
        default:
            break;
    }
    
    web.linkStr = [self.response.advRows[index] linkUrl];
    
    web.Adv = YES;
    web.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:web animated:YES];
        
    }
    
}

@end
