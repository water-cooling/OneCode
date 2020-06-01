//
//  PolicysListModel.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PolicysListModel : NSObject

@property(nonatomic,assign)NSString * addTimeStr;
@property(nonatomic,assign)NSInteger  appId;
@property(nonatomic,copy)NSString *  cFrom;
@property(nonatomic,copy)NSString * detailH5;
@property(nonatomic,copy)NSString * processDate;
@property(nonatomic,assign)NSInteger  dirtreeId;
@property(nonatomic,assign)NSInteger  ID;
@property(nonatomic,copy)NSString *  imgUrl;
@property(nonatomic,assign)NSInteger  tDjcs;
@property(nonatomic,copy)NSString *  tLjdz;
@property(nonatomic,copy)NSString *  tMain;
@property(nonatomic,copy)NSString *  tTitle;

@end





@interface PolicysListResponseModel : NSObject

@property(nonatomic,assign)NSInteger  count;
@property(nonatomic,strong)NSMutableArray * rows;



@end


@interface PolicysListdataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) PolicysListResponseModel * response;


@end

@interface PolicysListModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) PolicysListdataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end


