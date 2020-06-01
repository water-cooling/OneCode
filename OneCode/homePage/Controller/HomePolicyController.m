//
//  HomeNewsController.m
//  bihucj
//
//  Created by humengfan on 2018/7/17.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "HomePolicyController.h"
#import "HomeNewsCell.h"
#import <MJRefresh.h>
#import "WebViewController.h"
#import "HomeUntility.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface HomePolicyController ()

@property(nonatomic,strong) PolicysListResponseModel * response;
@property(nonatomic,copy)NSString * seachStr;
@property(nonatomic,assign)NSInteger DownIndex;
@end

@implementation HomePolicyController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.seachStr = @"";
    self.view.backgroundColor = [UIColor whiteColor ];

    [self.tableView registerNib:[UINib nibWithNibName:@"HomeNewsCell" bundle:nil] forCellReuseIdentifier:@"HomeNewsCell"];
   
    self.tableView.tableFooterView = [UIView new];

    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    __weak typeof(self) weakself = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.DownIndex = 1;
        
        [weakself.tableView.mj_footer resetNoMoreData];
        
        [weakself loadingHomeNewsDataLoc:self.DownIndex count:10 tTitleLike:self.seachStr refresh:YES];
        
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.DownIndex +=1;
        
        weakself.tableView.mj_footer.hidden = NO;
        
        [weakself loadingHomeNewsDataLoc:weakself.DownIndex count:10 tTitleLike:self.seachStr refresh:NO];
    }];
}

- (void)SeachContent:(NSString *)Str
{
    
    self.seachStr = Str;
    
    [self.tableView.mj_header beginRefreshing];
    
}


-(void)loadingHomeNewsDataLoc:(NSInteger)Loc count:(NSInteger)count tTitleLike:(NSString * )Str refresh:(BOOL)isdown{
    [HomeUntility GetHomegetPolicyspageNo:Loc pageSize:count tTitleLike:Str callback:^(PolicysListResponseModel *Response, FGError *error) {
        
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
            
         
            
            [self.tableView reloadData];
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
        }
        
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.response ? self.response.rows.count : 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HomeNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeNewsCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    PolicysListModel * model = self.response.rows[indexPath.row];
    
    cell.TitleLab.text = model.tTitle;
    
    [cell.RightIcon sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage new] options:SDWebImageLowPriority];

    
    cell.TimeLab.text = [NSString stringWithFormat:@"%@ %ld %@",model.cFrom,(long)model.tDjcs,model.processDate];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 105;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    PolicysListModel * model = self.response.rows[indexPath.row];
    
    [HomeUntility NewsLick:model.ID callback:^(SucceedModel *success, FGError *error) {
        
        if (!error) {
            
            WebViewController * web = [[WebViewController alloc]init];
            
            web.linkStr = model.detailH5;
            web.title = @"新闻政策详情";
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        
        
    }];
    
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
