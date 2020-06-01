//
//  ShareViewController.m
//  bihucj
//
//  Created by humengfan on 2018/8/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "ShareViewController.h"
#import <UMShare/UMSociallogMacros.h>
#import "UIImage+DrawImage.h"
#import <UMShare/UMShare.h>
#import <UShareUI/UShareUI.h>

@interface ShareViewController ()


@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.4];
    
 
}
- (IBAction)DIsmiss:(UIControl *)sender {
    
    [self.delegate shareLinkResult:NO AndCancel:YES];

    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)CancelClick:(UIButton *)sender {
    
    
    [self.delegate shareLinkResult:NO AndCancel:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)UIClick:(UIButton *)sender {

    
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

- (void)shareMusicToPlatformType:(UMSocialPlatformType)platformType
{
    //创建网页对象
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    UMShareWebpageObject * share;
    //创建音乐内容对象
    if (self.sharetilte) {
        
     share  = [UMShareWebpageObject shareObjectWithTitle:@"" descr:self.sharetilte thumImage:[UIImage imageNamed:@"defaultImg"]];
        
    }else
    {
        
    share = [UMShareWebpageObject shareObjectWithTitle:@"我正在使用【币虎财经】，推荐给你"descr:@"币虎在手，资讯、快讯、行情、糖果应有尽有" thumImage:[UIImage imageNamed:@"defaultImg"]];

    }
    
    share.webpageUrl = self.shareLink;
    
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
            
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                
                UMSocialShareResponse *resp = data;
                //分享结果消息
                NSLog(@"response message is %@",resp.message);
                //第三方原始返回的数据
                if ([resp.originalResponse isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary * dict = resp.originalResponse;
                }
                NSLog(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                NSLog(@"response data is %@",data);
            }
        
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
