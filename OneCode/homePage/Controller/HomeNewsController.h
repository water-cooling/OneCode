//
//  HomeNewsController.h
//  bihucj
//
//  Created by humengfan on 2018/7/17.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FGScrollviewDelegate.h"

@interface HomeNewsController : UITableViewController<FGScrollPageViewChildVcDelegate>

-(void)SeachContent:(NSString * )Str;

@property(nonatomic,assign)NSInteger SelectIndex;

@property(nonatomic,copy)NSString * seachStr;

@end
