//
//  UIColor+colorChange.h
//  FungusProject
//
//  Created by humengfan on 2018/5/7.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (colorChange)
+ (UIColor *)colorWithHexString: (NSString *)color;

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size ;
@end
