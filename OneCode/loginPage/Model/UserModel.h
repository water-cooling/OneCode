//
//  User.h
//  FungusProject
//
//  Created by humengfan on 2018/5/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageModel.h"
@interface UserModel : NSObject

@property(nonatomic,copy)NSString * sessionKey;
@property(nonatomic,copy)NSString * avatar;
@property(nonatomic,copy)NSString * nickName;
@property(nonatomic,assign)BOOL   flag;
@property(nonatomic,assign)NSInteger  readArticleNum;
@end


@interface UserDataModel : NSObject

@property(nonatomic,assign)double  time;
@property(nonatomic,strong)UserModel * response;

@end


@interface LoginModel : NSObject

@property(nonatomic,assign)int  code;
@property(nonatomic,strong)NSMutableArray * messages;
@property(nonatomic,strong)UserDataModel * data;


@end

