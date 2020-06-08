//
//  FastRecommandViewController.m
//  bihucj
//
//  Created by humengfan on 2018/8/1.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "FastRecommandViewController.h"
#import <UMShare/UMShare.h>
#import "UIImage+DrawImage.h"
#import "UserUtility.h"
#import "BaseNavigationController.h"
@interface FastRecommandViewController ()
@property(nonatomic,strong) NSMutableArray *shareArr;
@property(nonatomic,strong) UIImageView * shareImg;
@end

@implementation FastRecommandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage * image =    [UIImage addWatemarkTextAfteriOS7_WithLogoImageTimeText:self.ShareTime TitleText:self.ShareTitle contentText:self.ShareContent];

  self.shareImg = [[UIImageView alloc]initWithImage:image];
    NSLog(@"----%f",image.size.height);
    
    self.shareImg.contentMode = UIViewContentModeCenter;
    
    self.shareImg.frame = CGRectMake(53, 34, UISCREENWIDTH-106, image.size.height);
    
    [self.scrollview addSubview:self.shareImg];
    self.scrollview.contentSize = CGSizeMake(0, image.size.height);
    self.scrollview.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.4];
    [self initShareUI];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)UIClick:(UIButton *)sender {
    
    if (![UserUtility hasLogin]) {
        [self turnToLogin];
    }else{
    switch (sender.tag) {
           case UMSocialPlatformType_WechatSession:{
               if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession]) {
                   [self shareMusicToPlatformType:UMSocialPlatformType_WechatSession];
               }else{
                   [MBManager showBriefAlert:@"请安装微信"];
               }
           }
               break;
           case UMSocialPlatformType_WechatTimeLine:{
               if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatTimeLine]) {
                   
                   [self shareMusicToPlatformType:UMSocialPlatformType_WechatTimeLine];
               }else{
                   [MBManager showBriefAlert:@"请安装微信"];
               }
           }
               break;
           case UMSocialPlatformType_QQ:{
               if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]){
                   [self shareMusicToPlatformType:UMSocialPlatformType_QQ ];
               }else{
                   [MBManager showBriefAlert:@"请安装QQ"];
               }
           }
               break;
               
           case UMSocialPlatformType_Qzone:{
               
               if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]) {
                   
                   [self shareMusicToPlatformType:UMSocialPlatformType_Qzone];
                   
               }else{
                   [MBManager showBriefAlert:@"请安装QQ"];
               }
           }
               break;
           case UMSocialPlatformType_Sina:{
               if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_Sina]) {
                   
                   [self shareMusicToPlatformType:UMSocialPlatformType_Sina];
               }
               break;
           }
           default:
               break;
       }
    }
    
}

-(void)initShareUI{
    UIView *bottomView = [[UIView alloc]init];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-TabbarSafeBottomMargin);
        make.height.mas_equalTo(152);
    }];
    UIButton *cancelbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelbtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelbtn setTitleColor:[UIColor blackColor] forState:0];
    cancelbtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelbtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [bottomView addSubview:cancelbtn];
    [cancelbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(bottomView);
        make.height.mas_equalTo(49);
    }];
    [cancelbtn addTarget:self action:@selector(CancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIView * speatorView = [UIView new];
    speatorView.backgroundColor = [UIColor colorWithHexString:@"#F3F3F3"];
    [bottomView addSubview:speatorView];
    [speatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(bottomView);
        make.bottom.equalTo(cancelbtn.mas_top);
        make.height.mas_equalTo(1);
    }];
    
    CGFloat speator = (UISCREENWIDTH- 48*self.shareArr.count)/(self.shareArr.count+1);
    CGFloat width = 48;
    for (int i = 0; i<self.shareArr.count; i++) {
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title;
        NSString *icon;
        switch ([self.shareArr[i]integerValue]) {
            case UMSocialPlatformType_WechatSession:
                title = @"微信";
                icon = @"微信";
                break;
            case UMSocialPlatformType_WechatTimeLine:
                title = @"朋友圈";
                icon = @"朋友圈";
                break;
            case UMSocialPlatformType_QQ:
                title = @"QQ";
                icon = @"QQ";
                break;
            case UMSocialPlatformType_Qzone:
                title = @"QQ空间";
                icon = @"QQ空间";
                    break;
                case UMSocialPlatformType_Sina:
                title = @"新浪";
                icon = @"微博";
                break;
            default:
                break;
        }
        [shareBtn setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
        shareBtn.tag = [self.shareArr[i]integerValue];
        [shareBtn addTarget:self action:@selector(UIClick:) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:shareBtn];
       UILabel *titleDesLab = [UILabel new];
        titleDesLab.text = title;
        titleDesLab.textColor = [UIColor blackColor];
        titleDesLab.font = [UIFont systemFontOfSize:11];
        [bottomView addSubview:titleDesLab];
        titleDesLab.textAlignment = NSTextAlignmentCenter;
        shareBtn.frame = CGRectMake(speator+i*(speator+width), 15, width, width);
        titleDesLab.frame = CGRectMake(shareBtn.x, CGRectGetMaxY(shareBtn.frame)+15, width, 11);
        }
}

- (void)shareMusicToPlatformType:(UMSocialPlatformType)platformType{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareImageObject * share = [UMShareImageObject new];
    share.shareImage = self.shareImg.image;
    
    messageObject.shareObject = share;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            
            [self.delegate shareLinkResult:NO AndCancel:NO];

            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            
            [self.delegate shareLinkResult:YES AndCancel:NO];

            [self dismissViewControllerAnimated:YES completion:nil];
            
            
            NSLog(@"response data is %@",data);
        }
    }];
}

    
- (void)CancelClick {
    [self.delegate shareLinkResult:NO AndCancel:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)Dimiss:(id)sender {
    [self.delegate shareLinkResult:NO AndCancel:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(NSMutableArray *)shareArr{
    if (!_shareArr) {
        NSArray *ShareTypeArr = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sina)];
        _shareArr = [NSMutableArray array];
        for (NSNumber *type in ShareTypeArr) {
            if ([[UMSocialManager defaultManager]isInstall:type.integerValue]) {
                [_shareArr addObject:type];
            }
        }
    }
    return _shareArr;
}

@end
