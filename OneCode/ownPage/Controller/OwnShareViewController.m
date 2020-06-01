//
//  ShareViewController.m
//  bihucj
//
//  Created by humengfan on 2018/8/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "OwnShareViewController.h"
#import <UMShare/UMSociallogMacros.h>
#import "UIImage+DrawImage.h"
#import <UShareUI/UShareUI.h>
#import "AboutUntility.h"
#import "RecommandModel.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OwnShareViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property(nonatomic,strong) UIImageView * BakcImage;
@property(nonatomic,strong) UIImageView * QrCodeImg;
@property(nonatomic,strong) NSString * QrCodeStr;


@end

@implementation OwnShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage * Recommand = [UIImage imageNamed:@"Recommend"];
    
    self.BakcImage= [[UIImageView alloc]initWithImage:Recommand];
    
    self.BakcImage.frame = CGRectMake(0, 15,  Recommand.size.width,  Recommand.size.height+30);
    
    self.BakcImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.scrollview addSubview:self.BakcImage];
    
    
    self.QrCodeImg = [[UIImageView alloc]initWithFrame:CGRectMake(Recommand.size.width/2-65, Recommand.size.height-170, 130, 130)];
    
    [self.BakcImage addSubview:self.QrCodeImg];
    
    
    self.BakcImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.BakcImage.frame = CGRectMake(0, 0,UISCREENWIDTH, Recommand.size.height);
    
    [self.scrollview addSubview:self.BakcImage];
    
    self.scrollview.contentSize = CGSizeMake(0, Recommand.size.height+30);
    
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.4];
    
    [self QRCodeMethod:self.shareLink];
    
}


- (void)QRCodeMethod:(NSString *)qrCodeString {
    
    UIImage *qrcodeImg = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:qrCodeString] withSize:250.0f];
    // ** 将生成的
    self.QrCodeImg.image = qrcodeImg;
}

/*  ============================================================  */
#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
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
    //创建分享消息对象
    if (self.QrCodeStr) {
        
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        
        UMShareImageObject * share = [UMShareImageObject new];
        
        
        share.shareImage = [self.BakcImage.image addWatemarkTextAfteriOS7_WithImageQcode:self.QrCodeImg.image];
        
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
        
    }else
    {
        
        [MBManager showBriefAlert:@"二维码获取不正确，请重新刷新当前页面"];
        
    }
    
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
