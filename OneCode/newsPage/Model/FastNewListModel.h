//
//  FastNewLisModel.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FastNewListModel : NSObject

@property(nonatomic,copy)NSString * dateFormat;

@property(nonatomic,copy)NSString *  cFrom;

@property(nonatomic,copy)NSString * briefIntro;
@property(nonatomic,copy)NSString *  processDate;
@property(nonatomic,copy)NSString *detailH5;
@property(nonatomic,assign)NSInteger  dirtreeId;

@property(nonatomic,copy)NSString * addTimeStr;
@property(nonatomic,assign)NSInteger  ID;
@property(nonatomic,copy)NSString *  imgUrl;
@property(nonatomic,assign)NSInteger  tDjcs;
@property(nonatomic,copy)NSString *  tLjdz;
@property(nonatomic,copy)NSString *  tMain;
@property(nonatomic,copy)NSString * tOrder;

@property(nonatomic,copy)NSString *  tTitle;
@property(nonatomic,copy)NSString *  time;
@property(nonatomic,copy)NSString *  typeName;
@property(nonatomic,assign)NSInteger  updateTime;
@property(nonatomic,assign)BOOL  expand;


@end




@interface FastNewListResponseModel : NSObject

@property(nonatomic,assign)NSInteger  count;
@property(nonatomic,strong)NSMutableArray * rows;



@end


@interface FastNewListDataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) FastNewListResponseModel * response;


@end

@interface FastNewListModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) FastNewListDataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end



