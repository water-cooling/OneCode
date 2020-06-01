//
//  SignViewController.h
//  bihucj
//
//  Created by humengfan on 2018/8/21.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SignUntility.h"

@interface SignViewController : UIViewController

@property (nonatomic,strong)SignListdataModel * ListModel;

@property (nonatomic,strong)SignResponseModel * stateModel;

-(void)loginChangeUI:(SignResponseModel *)response;
@end
