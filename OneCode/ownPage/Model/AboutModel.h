//
//  AboutModel.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AboutModel : NSObject

@property(nonatomic,assign)NSString * busineCooperate;
@property(nonatomic,copy)NSString *  contribute;
@property(nonatomic,copy)NSString *  feedback;
@property(nonatomic,copy)NSString *  suppertWeChat;
@property(nonatomic,copy)NSString *   verson;
@property(nonatomic,copy)NSString *   weIconUrl;

@end




@interface AboutDataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) AboutModel * response;


@end

@interface AboutModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) AboutDataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end


