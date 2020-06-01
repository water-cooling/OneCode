//
//  MoneyDetailTableViewController.h
//  bihucj
//
//  Created by humengfan on 2018/9/13.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FGScrollviewDelegate.h"
@interface MoneyDetailTableViewController : UITableViewController<FGScrollPageViewChildVcDelegate>

@property(nonatomic,copy)NSString * TitleStr;
@end
