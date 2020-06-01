//
//  MySweetTableViewController.m
//  bihucj
//
//  Created by humengfan on 2018/8/30.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "MySweetTableViewController.h"
#import "SweetTableViewCell.h"
#import <MJRefresh.h>
#import "SignUntility.h"
@interface MySweetTableViewController ()
@property(nonatomic,assign)NSInteger DownIndex;
@property(nonatomic,strong)ownShowResponseModel * response;

@end

@implementation MySweetTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的糖果";
    
    self.tableView.tableFooterView = [UIView new];
//    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
//
//    [btn setTitle:@"糖果说明" forState:UIControlStateNormal];
//
//    btn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
//
//    [btn addTarget:self action:@selector(rightBarclick) forControlEvents:UIControlEventTouchUpInside];
//
//    [btn setTitleColor:buttonSelectBackgroundColor forState:UIControlStateNormal];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeVideoCell" bundle:nil] forCellReuseIdentifier:@"HomeVideoCell"];
    __weak typeof(self) weakself = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.DownIndex = 1;
        [weakself.tableView.mj_footer resetNoMoreData];
        
        [self loadingSweetData:self.DownIndex isRefresh:YES];

    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.DownIndex +=1;
        weakself.tableView.mj_footer.hidden = NO;
        
        [self loadingSweetData:self.DownIndex isRefresh:NO];
    }];
    
 
}

-(void)rightBarclick{
    
    
    
    
    
    
}

-(void)loadingSweetData:(NSInteger)count isRefresh:(BOOL)isdown{
    
    
    [SignUntility getOwnListArristoday:self.istoday pageSize:10 pageCount:count callback:^(ownShowResponseModel *response, FGError *error) {

        if (isdown) {
            
            [self.tableView.mj_header endRefreshing];
            
            if ( response.rows.count == 0) {
                
                [MBManager showBriefAlert:@"暂无数据"];
                
            }
            
        }else
        {
            
            if (response.rows.count == 0) {
                
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                
                return ;
            }
            
            [self.tableView.mj_footer endRefreshing];
        }
        if (!error) {
            
            if (isdown)  {
                
                self.response = response;

            }else
            {
                
                [self.response.rows addObjectsFromArray:response.rows];
                
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.response ? self.response.rows.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    SweetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SweetCell"];
    
    ownShowModel * model = self.response.rows[indexPath.row];
    
    cell.readLab.text =  model.remark;
    
    cell.countLab.text = [NSString stringWithFormat:@"+%.1f",model.aganPearl];
    
    cell.timeLab.text = model.addTime;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 70;
    
}


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
