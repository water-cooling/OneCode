//
//  UIImage+DrawImage.h
//  FungusProject
//
//  Created by humengfan on 2018/5/7.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (DrawImage)


+ (UIImage *)imageWithColor:(UIColor *)color Size:(CGSize)size;



+ (UIImage *)compressImage:(UIImage *)image toByte:(NSUInteger)maxLength;

-(NSData *)compressWithMaxLength:(NSUInteger)maxLength;


-(UIImage *)circleImage:(CGRect)rect;

+ (UIImage *)imageWithColor:(UIColor *)color;


+(UIImage *)addWatemarkTextAfteriOS7_WithLogoImageTimeText:(NSString *)TimeText TitleText:(NSString *)TitleText contentText:(NSString *)contentText;

-(UIImage *)addWatemarkTextAfteriOS7_WithLogoImageTimeText:(NSString *)TimeText Qcode:(UIImage *)image;

-(UIImage *)addWatemarkTextAfteriOS7_WithImageQcode:(UIImage *)image;

+(UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

@end
