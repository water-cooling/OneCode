//
//  MoneyDetailTableViewController.m
//  bihucj
//
//  Created by humengfan on 2018/9/13.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "MoneyDetailTableViewController.h"
#import "MoneyMarketUntility.h"
#import <MJRefresh.h>
#import "MoneyDetailTableViewCell.h"
@interface MoneyDetailTableViewController ()
@property(nonatomic,assign)NSInteger DownIndex;
@property(nonatomic,strong)moneyDetailResponseModel * response;
@end

@implementation MoneyDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    self.DownIndex = 1;
    
    self.tableView.tableHeaderView = [self Headview];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MoneyDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoneyDetailTableViewCell"];
    
    self.tableView.separatorStyle = UITableViewScrollPositionNone;
    
    __weak typeof(self) weakself = self;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakself.tableView.mj_footer resetNoMoreData];
        
        weakself.DownIndex = 1;
        
        [self getMoneyDetailType:self.TitleStr pageCount:self.DownIndex PageSize:10 Refresh:YES];

    }];
    
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.DownIndex +=1;
        
        [self getMoneyDetailType:self.TitleStr pageCount:self.DownIndex PageSize:10 Refresh:NO];

    }];

  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)zj_viewWillAppearForIndex:(NSInteger)index
{
    
    [self getMoneyDetailType:self.TitleStr pageCount:self.DownIndex PageSize:10 Refresh:YES];

}


-(void)getMoneyDetailType:(NSString *)type pageCount:(NSInteger)count PageSize:(NSInteger)PageSize Refresh:(BOOL)isdown{
 
    [MoneyMarketUntility GetdigiccyDetialPageSize:PageSize pageNo:count base:type callback:^(moneyDetailResponseModel *response, FGError *error) {
        
        if (isdown) {
            
            [self.tableView.mj_header endRefreshing];
            
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
            
        }else{
            
            [MBManager showBriefAlert:error.descriptionStr];
        }
        
        
        
    }];
    
    
}

-(UIView *)Headview{
    
    
    
    UIView  *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 40)];
    
    view.backgroundColor = [UIColor colorWithHexString:@"#FFF9E5"];
    UILabel * exchangeLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 16, 38, 10)];
    
    exchangeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    
    exchangeLab.textColor = titleColor;
    
    exchangeLab.textAlignment = NSTextAlignmentCenter;
    
    exchangeLab.text = @"交易所";
    
    [view addSubview:exchangeLab];
    
    UILabel * newpriceLab = [[UILabel alloc]initWithFrame:CGRectMake(111, 16, 70, 10)];
    
    newpriceLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    
    newpriceLab.textColor = titleColor;
    
    newpriceLab.textAlignment = NSTextAlignmentCenter;
    
    newpriceLab.text = @"最新成交价";
    
    [view addSubview:newpriceLab];

    UILabel * convertLab = [[UILabel alloc]initWithFrame:CGRectMake(UISCREENWIDTH - 110 - 70, 16, 70, 10)];
    
    convertLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    
    convertLab.textColor = titleColor;
    
    convertLab.textAlignment = NSTextAlignmentCenter;
    
    convertLab.text = @"兑换币种";
    
    [view addSubview:convertLab];

    
    
    UILabel * TimechangeLab = [[UILabel alloc]initWithFrame:CGRectMake(UISCREENWIDTH - 48 - 15, 16, 48, 10)];
    
    TimechangeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    
    TimechangeLab.textColor = titleColor;
    
    TimechangeLab.textAlignment = NSTextAlignmentCenter;
    
    TimechangeLab.text = @"交易所";
    
    [view addSubview:TimechangeLab];
    
    
    return view;

    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    return self.response ? self.response.rows.count : 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoneyDetailTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:@"MoneyDetailTableViewCell" forIndexPath:indexPath];
    
    moneyDetailModel * model = self.response.rows[indexPath.row];
    
    cell.tradeNameLab.text = model.exchangeName;
    
    cell.PriceLab.text = [NSString stringWithFormat:@"¥%.2f",model.close.doubleValue];
    
    cell.MoneykindLab.text = [NSString stringWithFormat:@"%@/%@",model.base,model.currency];
    
    cell.ChangeLab.text = [NSString stringWithFormat:@"%.2f%%",model.degree.doubleValue * 100];
    
    UIColor * color ;
    if ([model.closeArrow isEqualToString:@"0"]) {
        
        color = titleColor;
        
    }else if ([model.closeArrow isEqualToString:@"1"])
    {
        
        color = [UIColor colorWithHexString:@"#FF3333"];

    }else
    {
        
        color = [UIColor colorWithHexString:@"#23B04B"];
        

    }
    
    cell.ChangeLab.textColor = color;
    
    
    return cell;
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
