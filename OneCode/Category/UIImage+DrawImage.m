//
//  UIImage+DrawImage.m
//  FungusProject
//
//  Created by humengfan on 2018/5/7.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "UIImage+DrawImage.h"
#import "NSString+getWidth.h"
@implementation UIImage (DrawImage)


+ (UIImage *) imageWithColor:(UIColor *)color Size:(CGSize)size{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect rect=CGRectMake(0.0f, 0.0f, size.width, size.width);
    /*画填充圆
     */
    
    CGContextAddEllipseInRect(context,rect);
    
    [color set];
    
    // 3.渲染
    CGContextFillPath(context);
    
    UIGraphicsBeginImageContext(rect.size);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    
    return image ;
}


+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength {
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    if (data.length < maxLength) return image;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    UIImage *resultImage = [UIImage imageWithData:data];
    if (data.length < maxLength) return resultImage;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return resultImage;
}


-(NSData *)compressWithMaxLength:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}


- (UIImage *)circleImage:(CGRect)rect
{
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width/2] addClip];
    
    [self drawInRect:rect];
    
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    
    
    UIGraphicsEndImageContext();
    return output;
    
}


+(UIImage *)addWatemarkTextAfteriOS7_WithLogoImageTimeText:(NSString *)TimeText TitleText:(NSString *)TitleText  contentText:(NSString *)contentText{
    
    UIFont * titleFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    
    NSDictionary * titledict = @{NSFontAttributeName:titleFont,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1A1A1A"],NSParagraphStyleAttributeName:paragraphStyle};
    
    UIFont * contentFont = [UIFont fontWithName:@"PingFang-SC-Regular" size:12];
    
    NSMutableParagraphStyle *contentparagraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    contentparagraphStyle.alignment = NSTextAlignmentLeft;
    
    contentparagraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    contentparagraphStyle.lineSpacing = 10;
    
    NSDictionary * contentdict = @{NSFontAttributeName:contentFont,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"],NSParagraphStyleAttributeName:contentparagraphStyle};
    
    CGSize titlesize = [TitleText boundingRectWithSize:CGSizeMake(UISCREENWIDTH-152,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:titledict context:nil].size;
    
    CGSize contentsize = [contentText boundingRectWithSize:CGSizeMake(UISCREENWIDTH-152,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:contentdict context:nil].size;
    
    UIImage *image = [[UIImage imageNamed:@"shareImg"]resizableImageWithCapInsets:UIEdgeInsetsMake(187, 56, 133, 56) resizingMode:UIImageResizingModeStretch];
    
    int w =  UISCREENWIDTH-106;
    
    
    int h = 343 + titlesize.height + contentsize.height;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), NO, [UIScreen mainScreen].scale);
    
    [image drawInRect:CGRectMake(0, 0, w, h)];
    
    UIImage * IconImage =  [UIImage imageNamed:@"图标"];
    
    [IconImage drawInRect:CGRectMake(64, 26, 142, 36)];
    
    UIImage * timeImage =  [UIImage imageNamed:@"时间"];
    
    [timeImage drawInRect:CGRectMake(31, 136, 15, 15)];
    
    
    [TimeText drawInRect:CGRectMake(55, 136, w-50, 12) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:11],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#010101"]}];
    
    [TitleText drawInRect:CGRectMake(23, 159, w-46 , titlesize.height ) withAttributes:titledict];
    
    [contentText drawInRect:CGRectMake(23, 170 + titlesize.height, w-46,contentsize.height ) withAttributes:contentdict];
    
    CGFloat speatorHeight =  180 + titlesize.height + contentsize.height;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //2、设置起点
    
    [path moveToPoint:CGPointMake(16, speatorHeight + 15)];
    //设置终点
    
    [path setLineWidth:1.0];
    
    [path addLineToPoint:CGPointMake(w-16, speatorHeight + 15)];
    
    [[UIColor blackColor] setStroke];
    
    //3、渲染上下文到View的layer
    [path stroke];
    
    UIImage * Qcode =  [UIImage imageNamed:@"二维码"];
    
    [Qcode drawInRect:CGRectMake(23, speatorHeight + 32, 80, 80)];
    
    [@"长按二维码 下载壹码APP" drawInRect:CGRectMake(102 ,speatorHeight + 38, 135,15 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:10],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1A1A1A"]}];
    
    NSMutableAttributedString * attri = [[NSMutableAttributedString alloc]initWithString:@"注册即可获得688颗糖果" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:8],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1A1A1A"]}];
    
    [attri addAttribute:NSForegroundColorAttributeName value:themeColor range:[@"注册即可获得688颗糖果" rangeOfString:@"688"]];
    
    [attri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12] range:[@"注册即可获得688颗糖果" rangeOfString:@"688"]];
    
    
    [attri drawInRect:CGRectMake(102, speatorHeight + 58, 135,14 )];
    
    NSMutableAttributedString * secondattri = [[NSMutableAttributedString alloc]initWithString:@"邀请好友再送688颗糖果" attributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Regular" size:8],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#1A1A1A"]}];
    
    [secondattri addAttribute:NSForegroundColorAttributeName value:themeColor range:[@"邀请好友再送688颗糖果" rangeOfString:@"688"]];
    
    [secondattri addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Medium" size:12] range:[@"邀请好友再送688颗糖果" rangeOfString:@"688"]];
    
    
    [secondattri drawInRect:CGRectMake(102, speatorHeight + 77, 135,14 )];
    
    [@"每日登陆、签到、阅读、分享均有好礼相送" drawInRect:CGRectMake(102, speatorHeight + 95, 135,14 ) withAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"PingFang-SC-Medium" size:9],NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#8B8C8C"]}];
    
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)addWatemarkTextAfteriOS7_WithLogoImageTimeText:(NSString *)TimeText Qcode:(UIImage *)image

{
    int w = self.size.width;
    int h = self.size.height;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, w, h)];
    
    //3.绘制背景图片
    //    [image drawInRect:CGRectMake(114, 226, 130, 130)];
    
    UIFont * contentFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    
    NSDictionary * dict = @{NSFontAttributeName:contentFont,NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"],NSParagraphStyleAttributeName:paragraphStyle};
    
    CGSize titlesize = [TimeText boundingRectWithSize:CGSizeMake(66,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    NSString * Lefttit = @"扫描更有BTC惊喜";
    CGSize LeftSize = [Lefttit boundingRectWithSize:CGSizeMake(80,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    [Lefttit drawInRect:CGRectMake(30, h-LeftSize.height-2, 80,LeftSize.height ) withAttributes:dict];
    
    
    [TimeText drawInRect:CGRectMake(w-100, h-titlesize.height-2, 66,titlesize.height ) withAttributes:dict];
    
    
    //4.从上下文中获取新图片
    //5.关闭图形上下文
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //返回图片
    return newImage;
    
    
}


- (UIImage *)addWatemarkTextAfteriOS7_WithImageQcode:(UIImage *)image
{
    
    int w = self.size.width;
    int h = self.size.height;
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [UIScreen mainScreen].scale);
    [self drawInRect:CGRectMake(0, 0, w, h)];
    
    //3.绘制背景图片
    [image drawInRect:CGRectMake(self.size.width/2-65, self.size.height-170, 130, 130)];
    
    
    
    //4.从上下文中获取新图片
    //5.关闭图形上下文
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //返回图片
    return newImage;
    
    
}

+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
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


@end
