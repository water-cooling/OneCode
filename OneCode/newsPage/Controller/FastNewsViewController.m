//
//  FastNewsViewController.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "FastNewsViewController.h"
#import "NormalTableViewCell.h"
#import <MJRefresh.h>
#import "NewsUntility.h"
#import "FastRecommandViewController.h"
#import "NSString+getWidth.h"
#import "ResultTableViewController.h"
#import "AttriModelHeightModel.h"
#import "HomeUntility.h"
#import "SignUntility.h"
#import "WebViewController.h"
@interface FastNewsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,NewsCellClickDelegate,shareImgResultDelegate>
@property(nonatomic,strong)UISearchBar *searchbar;
@property(nonatomic,strong)UITableView * Newstableview;
@property(nonatomic,assign)NSInteger DownIndex;
@property(nonatomic) FastNewListResponseModel * response;
@property(nonatomic) AttriModelHeightModel * model;

@end

@implementation FastNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.model = [AttriModelHeightModel new];
    
    self.Newstableview.rowHeight = 0;
    self.Newstableview.sectionHeaderHeight = 0;
    self.Newstableview.sectionFooterHeight = 0;
    self.Newstableview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (UISCREENWIDTH-50), 44)];
    
    self.searchbar.frame = CGRectMake(0, 8, UISCREENWIDTH-100 ,28);
    
    [view addSubview:self.searchbar];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    button.frame =  CGRectMake(view.width - 35, 13, 35 , 16);
    [button addTarget:self action:@selector(seachClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    self.navigationItem.titleView = view;
    
    [self.Newstableview registerNib:[UINib nibWithNibName:@"NormalTableViewCell" bundle:nil] forCellReuseIdentifier:@"NormalTableViewCell"];
    
    self.Newstableview.tableFooterView = [UIView new];
    
    __weak typeof(self) weakself = self;
    self.Newstableview.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
    self.Newstableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        weakself.DownIndex = 1;
        
        [weakself.model resume];
        
        [weakself.Newstableview.mj_footer resetNoMoreData];
        
        [weakself loadingFastNewsDataLoc:self.DownIndex count:10 tTitleLike:@"" refresh:YES];
        
    }];
    
    [self.Newstableview.mj_header beginRefreshing];
    
    self.Newstableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakself.DownIndex +=1;
        
        weakself.Newstableview.mj_footer.hidden = NO;
        
        [weakself loadingFastNewsDataLoc:weakself.DownIndex count:10 tTitleLike:@"" refresh:NO];
    }];
}

-(void)loadingFastNewsDataLoc:(NSInteger)Loc count:(NSInteger)count tTitleLike:(NSString * )Str refresh:(BOOL)isdown{

    [NewsUntility GetFlashspageNo:Loc pageSize:count tTitleLike:Str callback:^(FastNewListResponseModel *Response, FGError *error) {
        if (isdown) {
            [self.Newstableview.mj_header endRefreshing];
            
            if (Response.rows.count == 0) {
                
                [MBManager showBriefAlert:@"暂无数据"];
            }
            
        }else
        {
            if (Response.rows.count == 0) {
                
                [self.Newstableview.mj_footer endRefreshingWithNoMoreData];
                
                return ;
            }
            
            [self.Newstableview.mj_footer endRefreshing];
        }
        if (!error) {
            
            if (isdown) {
                self.response = Response;
                
            }else{
                [self.response.rows addObjectsFromArray:Response.rows];
            }
            [self.Newstableview reloadData];

        
        }else{
            [MBManager showBriefAlert:error.descriptionStr];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)seachClick{
    
    if (self.searchbar.text  == nil || [self.searchbar.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入搜索内容"];
        
        return;
    }
    
    ResultTableViewController * ResultVC = [ResultTableViewController new];
    
    ResultVC.hidesBottomBarWhenPushed = YES;
    
    ResultVC.seachStr = self.searchbar.text;
    
    [self.navigationController pushViewController:ResultVC animated:NO];
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        
        [MBManager showBriefAlert:@"请输入搜索内容"];
        
        return;
    }
    ResultTableViewController * ResultVC = [[ResultTableViewController alloc]init];
    
    ResultVC.hidesBottomBarWhenPushed = YES;
    
    ResultVC.seachStr = self.searchbar.text;
    
    [self.navigationController pushViewController:ResultVC animated:NO];
    
    
}


#pragma tableviewDateSource



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.response ? self.response.rows.count : 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FastNewListModel * model = self.response.rows[indexPath.row];
    NormalTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"NormalTableViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    if ([model.Format isEqualToString:@""]) {
        
        cell.BottomHeight.constant = 0;

    }else
    {
        cell.BottomHeight.constant = 30;

    }

    cell.delegate = self;
    
    NSString * NewStr = [model.briefIntro stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NewStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentLeft;
    paragraphStyle.lineSpacing = 4;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [NewStr length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:14] range:NSMakeRange(0, NewStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:NSMakeRange(0, NewStr.length)];
    
    cell.tag= indexPath.row;
    
    cell.MoreBtn.hidden = model.expand;
    cell.titlelab.text = model.tTitle;
    
    cell.Contentlab.numberOfLines =  model.expand ? 0 :2;
    cell.Contentlab.attributedText = attributedString;
    
    [cell.Contentlab sizeToFit];

    cell.typeLab.text = model.typeName;
    cell.TimeLab.text  = model.time;
    cell.DesLab.text = model.Format;
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    FastNewListModel * model = self.response.rows[indexPath.row];
    CGFloat CellHeight =   [model.Format isEqualToString:@""] ? 0 : 30;
    CellHeight = CellHeight + 105 + [model.tTitle getLabel:[UIFont systemFontOfSize:16]  LabWdith:UISCREENWIDTH - 51];

    CellHeight = CellHeight + [self.model getSpaceLabelAttriCacheIndexPath:indexPath];
    if (indexPath.row == 0) {
        
        NSLog(@"%f-----%f-----%f",CellHeight,[model.tTitle getLabel:[UIFont systemFontOfSize:16]  LabWdith:UISCREENWIDTH - 51],[self.model getSpaceLabelAttriCacheIndexPath:indexPath]);
    }
  
    return ceilf(CellHeight);
}



-(void)MoreBtnClick:(NSInteger)SelectIndex btnState:(UIButton *)Sender{
    FastNewListModel * model = self.response.rows[SelectIndex];
    model.expand = YES;
    [self.model UpdateSpaceLabelAttriStr:[model.briefIntro stringByReplacingOccurrencesOfString:@" " withString:@""] HeightwithSpeace:5 withFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:14] withWidth:UISCREENWIDTH - 51 CacheIndexPath:[NSIndexPath indexPathForRow:SelectIndex inSection:0]];
         [self.Newstableview reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SelectIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}


-(void)ShareBtnClick:(NSInteger)SelectIndex{
    __weak typeof(self) weakself = self;
    FastNewListModel * fastmodel = self.response.rows[SelectIndex];
    dispatch_async(dispatch_get_main_queue(), ^{
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FastRecommandViewController *modelVC = [story instantiateViewControllerWithIdentifier:@"FastRecommandViewController"];
        modelVC.delegate = self;
        modelVC.definesPresentationContext = YES;
        weakself.tabBarController.tabBar.hidden = YES;
        modelVC.ShareContent = [fastmodel.briefIntro stringByReplacingOccurrencesOfString:@" " withString:@""];
        modelVC.ShareTime = fastmodel.addTimeStr;
        modelVC.ShareTitle = fastmodel.tTitle;
        modelVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [weakself presentViewController:modelVC animated:YES completion:nil];
    });
    
}

-(UITableView *)Newstableview{
    if (!_Newstableview) {
        _Newstableview = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _Newstableview.dataSource = self;
        _Newstableview.delegate = self;
        _Newstableview.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view addSubview:_Newstableview];
    }
    return _Newstableview;
}
-(UISearchBar *)searchbar{
    if (!_searchbar) {
        _searchbar =[[UISearchBar alloc]init];
        _searchbar.placeholder = @"搜索关键字";
        _searchbar.delegate = self;
        [_searchbar setImage:[UIImage imageNamed:@"小搜索"]forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];

        UITextField *textfield;
       if (@available(iOS 13.0, *)) {
       // 针对 13.0 以上的iOS系统进行处理
            NSUInteger numViews = [_searchbar.subviews count];
            for(int i = 0; i < numViews; i++) {
                if([[_searchbar.subviews objectAtIndex:i] isKindOfClass:[UITextField class]]) {
                    textfield = [_searchbar.subviews objectAtIndex:i];
                }
            }
        }else {
        // 针对 13.0 以下的iOS系统进行处理
            textfield = [_searchbar valueForKey:@"_searchField"];
       }
       textfield.borderStyle = UITextBorderStyleNone;
       [textfield setBackgroundColor:[UIColor whiteColor]];
       for (UIView *view in _searchbar.subviews) {
           for (UIView * subviews in view.subviews) {
               if ( [ subviews isKindOfClass:NSClassFromString(@"UISearchBarBackground").class]) {
                   
                   subviews.alpha = 0;
               }
           }
       }
        
        [[UISearchBar appearance] setSearchFieldBackgroundImage:[self searchFieldBackgroundImage] forState:UIControlStateNormal];
        [textfield setDefaultTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.5]}];
        _searchbar.searchTextPositionAdjustment = UIOffsetMake(7, 0);

    }
    return _searchbar;
}

-(void)shareLinkResult:(BOOL)result AndCancel:(BOOL)cancel{
    self.tabBarController.tabBar.hidden = NO;
    if (cancel) {
        return;
    }
    if (result) {
        [SignUntility shareArticlecallback:^(SucceedModel *response, FGError *error){
            if (!error) {
                NSString *LabelText;
                if (response.pearl.integerValue == 0) {
                    LabelText = response.shareFlash;
                }else{
                    LabelText = [NSString stringWithFormat:@"恭喜你+%@糖果",response.pearl];
                }
                [ShowStateView showStateViewTitle:LabelText StateType:StateCenter autoClear:YES AutoclearClearTimer:2];
            }else{
                [MBManager showBriefAlert:error.descriptionStr];
            }
        }];
    }else{
        [MBManager showBriefAlert:@"分享失败"];
        
    }
    
}

- (UIImage*)searchFieldBackgroundImage {
    UIColor*color = [UIColor whiteColor];
    CGFloat cornerRadius = 5;
    CGRect rect =CGRectMake(0,0,28,28);
    
    UIBezierPath*roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth=0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    
    UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)setLeftPlaceholder {
    SEL centerSelector = NSSelectorFromString([NSString stringWithFormat:@"%@%@", @"setCenter", @"Placeholder:"]);
    if ([self respondsToSelector:centerSelector]) {
        BOOL centeredPlaceholder = NO;
        NSMethodSignature *signature = [[UISearchBar class] instanceMethodSignatureForSelector:centerSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        [invocation setTarget:self];
        [invocation setSelector:centerSelector];
        [invocation setArgument:&centeredPlaceholder atIndex:2];
        [invocation invoke];
    }
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
