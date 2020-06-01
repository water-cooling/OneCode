//
//  ownShowModel.h
//  bihucj
//
//  Created by humengfan on 2018/8/30.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ownShowModel : NSObject

@property(nonatomic,copy)NSString * addTime;
@property(nonatomic,assign)CGFloat  aganPearl;
@property(nonatomic,copy)NSString * appId;
@property(nonatomic,assign)NSInteger  delFlag;
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * pearlType;
@property(nonatomic,copy)NSString * updateTime;
@property(nonatomic,copy)NSString * userId;
@property(nonatomic,copy)NSString * remark;


@end


@interface ownShowResponseModel : NSObject

@property(nonatomic,strong)NSMutableArray * rows;

@property(nonatomic,assign)NSInteger count;


@end


@interface ownShowDataModel : NSObject

@property (nonatomic,strong)ownShowResponseModel * response;

@property(nonatomic,copy)NSString * time;


@end


@interface ownShowModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) ownShowDataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;

@end
