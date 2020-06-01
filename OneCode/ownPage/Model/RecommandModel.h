//
//  RecommandModel.h
//  bihucj
//
//  Created by humengfan on 2018/8/1.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommandModel : NSObject

@property(nonatomic,assign)NSString * qrCode;
@property(nonatomic,copy)NSString *  shareUrl;
@property(nonatomic,copy)NSString * invateCode;

@end

@interface RecommandDataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) RecommandModel * response;


@end

@interface RecommandModels : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) RecommandDataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end
