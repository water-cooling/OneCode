//
//  moneyDetailModel.h
//  bihucj
//
//  Created by humengfan on 2018/9/13.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface moneyDetailModel : NSObject

@property (nonatomic,copy) NSString * appId;
@property (nonatomic,copy) NSString * base;
@property (nonatomic,copy) NSString * changValue;
@property (nonatomic,copy) NSString * close;
@property (nonatomic,copy) NSString * closeArrow;
@property (nonatomic,copy) NSString * commissionRatio;
@property (nonatomic,copy) NSString * currency;
@property (nonatomic,copy) NSString * dateTime;
@property (nonatomic,copy) NSString * degree;
@property (nonatomic,copy) NSString * exchangeImgUrl;
@property (nonatomic,copy) NSString * exchangeName;
@property (nonatomic,copy) NSString * high;
@property (nonatomic,copy) NSString * low;
@property (nonatomic,copy) NSString * open;
@property (nonatomic,copy) NSString * quantityRatio;
@property (nonatomic,copy) NSString * symbol;
@property (nonatomic,copy) NSString * ticker;
@property (nonatomic,copy) NSString * turnoverRate;
@property (nonatomic,copy) NSString * value;
@property (nonatomic,copy) NSString * vol;

@end

@interface moneyDetailResponseModel : NSObject

@property(nonatomic,assign)NSInteger  count;
@property(nonatomic,strong)NSMutableArray * rows;
@end



@interface moneyDetailDataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) moneyDetailResponseModel * response;

@end

@interface moneyDetailModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) moneyDetailDataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end





















