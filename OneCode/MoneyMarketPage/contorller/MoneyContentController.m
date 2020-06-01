//
//  MyOrderViewController.m
//  FungusProject
//
//  Created by humengfan on 2018/5/25.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "MoneyContentController.h"
#import "FGContentView.h"
#import "FGScrollviewDelegate.h"
#import "FGScrollSegmentView.h"
#import "MoneyMarketUntility.h"
#import "MoneyDetailTableViewController.h"
@interface MoneyContentController()<FGScrollviewDelegate>
@property(nonatomic,strong) NSMutableArray*response;
@property(nonatomic,strong)FGScrollSegmentView *segmentView;
@property(nonatomic,strong)NSMutableArray *titleArr;

@property(nonatomic,strong)FGContentView * contentView;
@end


@implementation MoneyContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"实时行情";
    [self loadingTitleArrData];
    
    
    
}

-(void)popLastVC{
    
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)loadingTitleArrData{

    [MoneyMarketUntility GetdigiccyTitlecallback:^(NSMutableArray *response, FGError *error) {

        if (!error) {

            self.response = response;


          
            [self.view addSubview:self.segmentView];

            [self.view addSubview:self.contentView];


        }else
        {

            [MBManager showBriefAlert:error.descriptionStr];
        }

    }];

}

-(NSInteger)numberOfChildViewControllers
{
    
    return self.response.count;
    
}

-(UIViewController<FGScrollPageViewChildVcDelegate> *)childViewController:(UIViewController<FGScrollPageViewChildVcDelegate> *)reuseViewController forIndex:(NSInteger)index{
    
    
    MoneyDetailTableViewController *childVc = (MoneyDetailTableViewController *)reuseViewController;

    if (childVc == nil) {

        childVc =   [[MoneyDetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
    }


    return childVc;
    
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllDidAppear:(UIViewController *)childViewController forIndex:(NSInteger)index
{

    
    
    
}

- (void)scrollPageController:(UIViewController *)scrollPageController childViewControllWillAppear:(UIViewController *)childViewController forIndex:(NSInteger)index
{
    
    MoneyDetailTableViewController *childVc = (MoneyDetailTableViewController *)childViewController;
    
    childVc.TitleStr = self.response[index];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(FGScrollSegmentView *)segmentView{
    
    if (!_segmentView) {
        __weak typeof(self) weakSelf = self;
        
        _segmentView = [[FGScrollSegmentView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, UISCREENWIDTH, 40) WithTitleArr:self.response delegate:self titleDidClick:^(NSString *Str, NSInteger index) {
            
            [weakSelf.contentView setContentOffSet:CGPointMake(weakSelf.contentView.width * index, 0.0) animated:NO];
            
        }];
        _segmentView.backgroundColor = [UIColor whiteColor];
        _segmentView.layer.borderWidth = 1;
        _segmentView.layer.borderColor = [UIColor colorWithHexString:@"#F3F3F3"].CGColor;
    }
    return _segmentView;
}

- (FGContentView *)contentView {
    if (_contentView == nil) {
        
        FGContentView *content = [[FGContentView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight + 40, UISCREENWIDTH, UISCREENHEIGHT-SafeAreaTopHeight-40) segmentView:self.segmentView parentViewController:self delegate:self];
        _contentView = content;
    }
    return _contentView;
}

#pragma Mark Delegate


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
