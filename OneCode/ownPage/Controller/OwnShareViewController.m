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
#import "UIImage+DrawImage.h"
@interface OwnShareViewController ()
@property (nonatomic, strong) NSMutableArray *shareArr;
@property(nonatomic,strong) UIImageView * BakcImage;
@property(nonatomic,strong) UIImageView * QrCodeImg;
@property(nonatomic,strong) NSString * QrCodeStr;
@end

@implementation OwnShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.4];
    [self initShareUI];
    
}


/*  ============================================================  */
#pragma mark - InterpolatedUIImage

-(void)initShareUI{
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(DIsmiss)];
    [self.view addGestureRecognizer:tap];
    UIImage * Recommand = [UIImage imageNamed:@"Recommend"];
      self.BakcImage= [[UIImageView alloc]initWithImage:Recommand];
      [self.view addSubview:self.BakcImage];
      self.BakcImage.contentMode = UIViewContentModeScaleAspectFit;
      [self.BakcImage mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.view).offset(72.5+SafeAreaTopHeight);
          make.left.equalTo(self.view).offset(38);
          make.right.equalTo(self.view).offset(-38);
          make.height.mas_equalTo(400);
      }];
      self.QrCodeImg = [[UIImageView alloc]init];
      [self.BakcImage addSubview:self.QrCodeImg];
      [self.QrCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self.BakcImage).offset(79);
          make.bottom.equalTo(self.BakcImage).offset(-11);
          make.size.mas_equalTo(CGSizeMake(140, 140));
      }];
    [self QRCodeMethod:self.shareLink];
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
- (void)QRCodeMethod:(NSString *)qrCodeString {
    UIImage *qrcodeImg = [UIImage createNonInterpolatedUIImageFormCIImage:[self createQRForString:qrCodeString] withSize:250.0f];
    // ** 将生成的
    self.QrCodeImg.image = qrcodeImg;
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


- (void)DIsmiss{
    [self.delegate shareLinkResult:NO AndCancel:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)CancelClick {
    [self.delegate shareLinkResult:NO AndCancel:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)UIClick:(UIButton *)sender {
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

- (void)shareMusicToPlatformType:(UMSocialPlatformType)platformType{
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
