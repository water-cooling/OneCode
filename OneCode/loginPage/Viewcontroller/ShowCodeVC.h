//
//  ShowCodeVC.h
//  FungusProject
//
//  Created by humengfan on 2018/5/12.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//


typedef void(^ResultBlock)(BOOL state,NSString * ID,NSString* ImageValue);


#import <UIKit/UIKit.h>

@interface ShowCodeVC : UIViewController

@property (nonatomic,copy)NSString * ImageURL;

@property(nonatomic,copy)ResultBlock  block;
@end
