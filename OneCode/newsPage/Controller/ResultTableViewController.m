//
//  ResultTableViewController.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "ResultTableViewController.h"
#import "ResultTableViewCell.h"
#import "NewsUntility.h"
#import "FastRecommandViewController.h"
#import <MJRefresh.h>
#import "NSString+getWidth.h"
#import "AttriModelHeightModel.h"
#import "HomeUntility.h"
#import "SignUntility.h"
#import "WebViewController.h"
@interface ResultTableViewController ()<UISearchBarDelegate,ResultCellClickDelegate,shareImgResultDelegate>
@property(nonatomic,strong)UISearchBar *searchbar;
@property(nonatomic,assign)NSInteger DownIndex;
@property(nonatomic) FastNewListResponseModel * response;
@property(nonatomic,strong)UILabel *CountLab;
@property(nonatomic) AttriModelHeightModel * model;

@end

@implementation ResultTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.DownIndex = 1;
    self.model = [AttriModelHeightModel new];

    self.view.backgroundColor = [UIColor whiteColor ];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH-35-15, 44)];
    self.searchbar.frame = CGRectMake(0, 8, 275*iPhonescale ,28);
    [view addSubview:self.searchbar];
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"搜索" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    button.frame =  CGRectMake(view.width - 35, 13, 35 , 16);
    [button addTarget:self action:@selector(seachClick) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    self.navigationItem.titleView = view;
    
    self.searchbar.text = self.seachStr;
    
    UIView * ShowView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, 34)];
    
    ShowView.backgroundColor = [[UIColor colorWithHexString:@"#F98040"]colorWithAlphaComponent:0.2];
     self.CountLab = [[UILabel alloc]initWithFrame:CGRectMake(UISCREENWIDTH/2 - 106/2, 11, 106, 12)];
    
    self.CountLab.textColor = [UIColor colorWithHexString:@"#333333"];
    self.CountLab.font = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    self.CountLab.text  =   @"";
    [ShowView addSubview:self.CountLab];
    
    self.tableView.tableHeaderView = ShowView;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultTableViewCell" bundle:nil] forCellReuseIdentifier:@"ResultTableViewCell"];

    [self loadingFastNewsDataLoc:self.DownIndex count:10 tTitleLike:self.seachStr refresh:YES];


self.tableView.tableFooterView = [UIView new];

__weak typeof(self) weakself = self;
self.tableView.estimatedRowHeight = 0;
self.tableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);

self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
    
    weakself.DownIndex +=1;
    
    [weakself.model resume];

    weakself.tableView.mj_footer.hidden = NO;
    
    [weakself loadingFastNewsDataLoc:weakself.DownIndex count:10 tTitleLike:self.seachStr refresh:NO];
}];
}

-(void)loadingFastNewsDataLoc:(NSInteger)Loc count:(NSInteger)count tTitleLike:(NSString * )Str refresh:(BOOL)isdown{
    
    [NewsUntility GetFlashspageNo:Loc pageSize:count tTitleLike:Str callback:^(FastNewListResponseModel *Response, FGError *error) {
        
        
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
            self.CountLab.text  = [NSString stringWithFormat:@"共有%ld条相关结果",(long)self.response.count] ;


            [self.tableView reloadData];
            
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
        }
        
        
    }];
    
    
    
}




-(void)seachClick{
    
    if (self.searchbar.text  == nil || [self.searchbar.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入搜索内容"];
        
        return;
    }
    
    [self.tableView.mj_footer resetNoMoreData];
  
    [self loadingFastNewsDataLoc:self.DownIndex count:10 tTitleLike:self.seachStr refresh:YES];
    
    self.seachStr = self.searchbar.text;
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    if (searchBar.text == nil || [searchBar.text length] <= 0) {
        
        [MBManager showBriefAlert:@"请输入搜索内容"];
        
        return;
    }
    [self.tableView.mj_footer resetNoMoreData];
    
    [self loadingFastNewsDataLoc:self.DownIndex count:10 tTitleLike:self.seachStr refresh:YES];
    
    self.seachStr = self.searchbar.text;
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shareLinkResult:(BOOL)result AndCancel:(BOOL)cancel
{
    
    self.tabBarController.tabBar.hidden = NO;

    if (cancel) {
        
        
        return;
        
    }

    if (result) {
        
        
        [SignUntility shareArticlecallback:^(SucceedModel *response, FGError *error) {
            
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
        
        
        
    }else
    {
        
        [MBManager showBriefAlert:@"分享失败"];
        
    }
    
    
    
    
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
   
    return self.response ? self.response.rows.count : 0;
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FastNewListModel * model = self.response.rows[indexPath.row];
    
    ResultTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell" forIndexPath:indexPath];

    cell.TitleLab.text = model.tTitle;
    
    cell.delegate = self;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString * NewStr = [model.briefIntro stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NewStr];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    [paragraphStyle setLineSpacing:4];//调整行间距
    
    cell.MoreBtn.hidden = model.expand;
    
    cell.ContentLab.numberOfLines =  model.expand ? 0 :2;


    cell.tag= indexPath.row;
    
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [NewStr length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:14] range:NSMakeRange(0, NewStr.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#333333"] range:NSMakeRange(0, NewStr.length)];

    cell.ContentLab.attributedText = attributedString;
    [cell.ContentLab sizeToFit];
    cell.typeLab.text = model.typeName;
    cell.TimeLab.text  = model.time;
    cell.ShareBtn.tag = indexPath.row;


    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FastNewListModel * model = self.response.rows[indexPath.row];
    
    
    CGFloat CellHeight =  105 + [model.tTitle getLabel:[UIFont systemFontOfSize:16]  LabWdith:UISCREENWIDTH - 51];
    
    
    CellHeight = CellHeight + [ self.model getSpaceLabelAttriCacheIndexPath:indexPath];
    
    
    return ceilf(CellHeight);
}



-(void)MoreBtnClick:(NSInteger)SelectIndex btnState:(UIButton *)Sender
{
    
    FastNewListModel * model = self.response.rows[SelectIndex];
    
    model.expand = YES;

    [self.model UpdateSpaceLabelAttriStr:[model.briefIntro stringByReplacingOccurrencesOfString:@" " withString:@""] HeightwithSpeace:5 withFont:[UIFont fontWithName:@"PingFang-SC-Regular" size:14] withWidth:UISCREENWIDTH - 51 CacheIndexPath:[NSIndexPath indexPathForRow:SelectIndex inSection:0]];
    
    
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SelectIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    
    
}


-(void)ShareBtnClick:(NSInteger)SelectIndex
{
    
    __weak typeof(self) weakself = self;
    
    
    FastNewListModel * fastmodel = self.response.rows[SelectIndex];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        FastRecommandViewController *modelVC = [story instantiateViewControllerWithIdentifier:@"FastRecommandViewController"];
        
        modelVC.definesPresentationContext = YES;
        
        weakself.tabBarController.tabBar.hidden = YES;
        
        modelVC.ShareContent = fastmodel.briefIntro;
        
        modelVC.delegate = self;
        
      
        
        modelVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        
        [weakself presentViewController:modelVC animated:YES completion:nil];
    });
    
}



-(UISearchBar *)searchbar{
    
    if (_searchbar == nil) {
        
        _searchbar = [[UISearchBar alloc]init];
        _searchbar.placeholder = @"搜索关键字";
        UITextField *textfield = [_searchbar valueForKey:@"searchField"];
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
        UITextField *txfSearchField = [_searchbar valueForKey:@"_searchField"];
        [txfSearchField setDefaultTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.5]}];
        
        _searchbar.searchTextPositionAdjustment = UIOffsetMake(7, 0);
        
        textfield.layer.cornerRadius = 14;
        textfield.layer.masksToBounds = YES;
        [textfield setValue: [UIColor colorWithHexString:@"#949494"] forKeyPath:@"_placeholderLabel.textColor"];
        
        [textfield setValue:[UIFont boldSystemFontOfSize:12]forKeyPath:@"_placeholderLabel.font"];
        
        [_searchbar setImage:[UIImage imageNamed:@"小搜索"]forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
        _searchbar.delegate = self;
        
        _searchbar.showsBookmarkButton = NO;
        
        if ([[UIDevice currentDevice] systemVersion].doubleValue >= 11.0) {
            
            textfield.frame = CGRectMake(12, 8, _searchbar.width, 28);
            
        }else{
            
            textfield.frame = CGRectMake(0, 8, _searchbar.width, 28);
            
            [self setLeftPlaceholder];
        }
        
        
    }
    
    return _searchbar;
    
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

@end
