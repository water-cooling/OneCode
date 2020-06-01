//
//  OwnCountModel.h
//  bihucj
//
//  Created by humengfan on 2018/8/30.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnCountModel : NSObject


@property(nonatomic,assign)NSString * todayTotal;
@property(nonatomic,copy)NSString *  total;
@property(nonatomic,copy)NSString * invateUrl;
@end


@interface OwnCountDataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) OwnCountModel * response;


@end

@interface OwnCountModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) OwnCountDataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end
