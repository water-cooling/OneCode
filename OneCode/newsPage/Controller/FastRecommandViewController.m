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
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)UIClick:(UIButton *)sender {
    
    if (![UserUtility hasLogin]) {
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        BaseNavigationController *vc = [story instantiateViewControllerWithIdentifier:@"BaseNavigationController"];
        
        [self presentViewController:vc animated:YES completion:nil];
        
        
    }else{
    
    switch (sender.tag) {
        case 100:
        {
            
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatSession]) {
                
                [self shareMusicToPlatformType:UMSocialPlatformType_WechatSession];
                
            }else
                
            {
                
                [MBManager showBriefAlert:@"请安装微信"];
            }
        }
            break;
            
        case 101:
        {
            
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_WechatTimeLine]) {
                
                [self shareMusicToPlatformType:UMSocialPlatformType_WechatTimeLine];
                
            }else
                
            {
                
                [MBManager showBriefAlert:@"请安装微信"];
            }
            
        }
            break;
            
        case 102:{
            
            
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ])
            {
                [self shareMusicToPlatformType:UMSocialPlatformType_QQ ];
                
            }else
                
            {
                
                [MBManager showBriefAlert:@"请安装QQ"];
            }
            
        }
            break;
            
        case 103:{
            
            if ([[UMSocialManager defaultManager]isInstall:UMSocialPlatformType_QQ]) {
                
                [self shareMusicToPlatformType:UMSocialPlatformType_Qzone];
                
            }else
                
            {
                
                [MBManager showBriefAlert:@"请安装QQ"];
            }
            
        }
            break;
            
        case 104:{
            
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

- (void)shareMusicToPlatformType:(UMSocialPlatformType)platformType
{
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

    
- (IBAction)CancelClick:(id)sender {
    
    
    [self.delegate shareLinkResult:NO AndCancel:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}
- (IBAction)Dimiss:(id)sender {
    
    [self.delegate shareLinkResult:NO AndCancel:YES];

    [self dismissViewControllerAnimated:YES completion:nil];
    
    
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
