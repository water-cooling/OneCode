//
//  CancelFollowModel.h
//  FungusProject
//
//  Created by humengfan on 2018/5/28.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SucceedModel : NSObject

@property(nonatomic,copy)NSString * pearlNum;
@property(nonatomic,copy)NSString * pearl;
@property(nonatomic,assign)BOOL flag;
@property(nonatomic,assign)BOOL signIn;
@property(nonatomic,copy)NSString *shareFlash;

@property(nonatomic,copy)NSString *readArticle;
@property(nonatomic,copy)NSString * shareArticle;
@property(nonatomic,copy)NSString *invateUrl;
@end

@interface SucceedDataModel : NSObject

@property (nonatomic,assign)long long int time;

@property (nonatomic,strong) SucceedModel * response;


@end

@interface SucceedModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) SucceedDataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end
