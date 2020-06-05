//
//  WebViewController.m
//  FungusProject
//
//  Created by humengfan on 2018/6/27.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>
#import "ShowStateView.h"
#import "ShareViewController.h"
#import "SignUntility.h"
@interface WebViewController ()<shareLinkResultDelegate,WKNavigationDelegate>
@property(nonatomic,strong)WKWebView * webview;
@property(nonatomic,strong)UIButton * shareBtn;

@property(nonatomic,strong)UIImageView * downImg;

@property(nonatomic,strong)dispatch_source_t  timer;

@property(nonatomic,strong)UILabel * timeLab;


@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.Adv) {
        
        self.webview = [[WKWebView alloc]initWithFrame:self.view.bounds];
        
        [self.view addSubview:self.webview];

    }else
    {
    
    self.webview = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, UISCREENWIDTH, UISCREENHEIGHT-45)];
        
        [self.view addSubview:self.webview];
        
        self.webview.navigationDelegate = self;

    }

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?hideDown=1",self.linkStr]];
    // 3.创建Request
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    // 4.加载网页
    [ self.webview loadRequest:request];
    

    
    // Do any additional setup after loading the view.
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
   NSNumber * count =  [[NSUserDefaults standardUserDefaults]objectForKey:@"readArticleNum"];

    if (!self.Adv) {

    if (count && [count integerValue] > 0) {
   
    self.downImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"read"]];
    
    self.downImg.frame = CGRectMake(UISCREENWIDTH-75, UISCREENHEIGHT-126, 60, 70);
    
    [self.view addSubview: self.downImg];
    
    self.timeLab = [[UILabel alloc]initWithFrame:CGRectMake(8, self.downImg.height-27, 52, 12)];
    
    [self.downImg addSubview:self.timeLab];
    
    self.timeLab.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:9];
    
    }else
    {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"readArticleNum"];
        
    }
        
        [self.shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self codeNumberRun];
    }
    
}



-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    
    if (_timer) {
        
        dispatch_source_cancel(_timer);
        
        _timer = nil;
    }
   
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)codeNumberRun{
    
    __block NSInteger time = 9; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(self.timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(self.timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮的样式
                [self.downImg removeFromSuperview];
                NSInteger count =    [[[NSUserDefaults standardUserDefaults]objectForKey:@"readArticleNum"]integerValue];
                
                [[NSUserDefaults standardUserDefaults]setObject:@(count -1) forKey:@"readArticleNum"];

                [self readArict];
            });
            
        }else{
            int seconds = time % 10 ;
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置按钮显示读秒效果
                self.timeLab.text =  [NSString stringWithFormat:@"倒计时%d秒", seconds];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
}


-(void)readArict{
    
    [SignUntility ReadArticlecallback:^(SucceedModel *response, FGError *error) {
       
        if (!error) {
            
            NSString * LabelText;
            
            if (response.pearl.integerValue == 0) {
                
                LabelText = response.readArticle;
            }else{
                
                LabelText = [NSString stringWithFormat:@"恭喜你+%@糖果",response.pearl];
            }
            [ShowStateView showStateViewTitle:LabelText StateType:StateCenter autoClear:YES AutoclearClearTimer:2];

            
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
            
        }
        
        
    }];
    
    
}

- (void)shareLinkResult:(BOOL)result AndCancel:(BOOL)cancel{
    
    if (self.timer) {
        
        dispatch_resume(_timer);
    }
    if (result) {
        
        [SignUntility shareLinkcallback:^(SucceedModel *response, FGError *error) {
            
            if (!error) {
                
                NSString * LabelText;
                
                if (response.pearl.integerValue == 0) {
                    
                    LabelText = response.shareArticle;
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



-(void)shareClick{
    
    ShareViewController * share = [[ShareViewController alloc]initWithNibName:@"ShareViewController" bundle:nil];
    share.delegate = self;
    share.shareLink =   [NSString stringWithFormat:@"%@?hideDown=0",self.linkStr];
    if (self.timer) {
        dispatch_suspend(_timer);
    }
    share.definesPresentationContext = YES;
    share.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self.navigationController  presentViewController:share animated:NO completion:nil];
}

-(UIButton *)shareBtn
{
    
    if (!_shareBtn) {
        
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _shareBtn.frame = CGRectMake(15, UISCREENHEIGHT-45, UISCREENWIDTH-30, 40);
        
        _shareBtn.layer.cornerRadius = 20;
        
        _shareBtn.layer.masksToBounds = YES;
        _shareBtn.backgroundColor = buttonSelectBackgroundColor;
        
        [_shareBtn  setTitleColor:titleColor forState:UIControlStateNormal];
        
        [_shareBtn setTitle:@"分享获得糖果" forState:UIControlStateNormal];
        
        [self.view addSubview: _shareBtn];
        
    }
    
    
    return _shareBtn;
    
    
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
