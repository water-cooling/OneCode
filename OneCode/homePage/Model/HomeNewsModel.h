//
//  HomeNewsModel.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeNewsModel : NSObject

@property(nonatomic,copy)NSString * addTimeStr;
@property(nonatomic,copy)NSString *  cFrom;
@property(nonatomic,copy)NSString *  ctrl0;
@property(nonatomic,copy)NSString *  ctrl1;
@property(nonatomic,copy)NSString *detailH5;
@property(nonatomic,copy)NSString *briefIntro;
@property(nonatomic,assign)NSInteger  dirtreeId;
@property(nonatomic,assign)NSInteger  ID;
@property(nonatomic,copy)NSString *  imgUrl;
@property(nonatomic,copy)NSString *  keywords;
@property(nonatomic,assign)NSInteger  tDjcs;
@property(nonatomic,copy)NSString *  tLjdz;
@property(nonatomic,copy)NSString *processDate;
@property(nonatomic,copy)NSString *  tMain;
@property(nonatomic,copy)NSString *  tTitle;
@property(nonatomic,assign)NSInteger  updateTime;

@end


@interface BannerModel : NSObject

@property(nonatomic,assign)NSInteger  dirtreeId;
@property(nonatomic,assign)NSInteger  ID;
@property(nonatomic,copy)NSString *  imgUrl;
@property(nonatomic,copy)NSString * linkUrl;
@end


@interface HomeNewsResponseModel : NSObject

@property(nonatomic,assign)NSInteger  count;
@property(nonatomic,strong)NSMutableArray * advRows;
@property(nonatomic,strong)NSMutableArray * rows;



@end


@interface HomeNewsdataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) HomeNewsResponseModel * response;


@end

@interface HomeNewsModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) HomeNewsdataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end




