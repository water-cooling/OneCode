//
//  ImageModel.h
//  FungusProject
//
//  Created by humengfan on 2018/5/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MessageModel.h"
@interface ImageModel : NSObject

@property(nonatomic,copy)NSString * imgId;
@property(nonatomic,copy)NSString * imgUrl;

@end


@interface ImageDataModel : NSObject


@property(nonatomic,assign)double  time;
@property(nonatomic,strong)ImageModel *response ;

@end

@interface CodeImageModel : NSObject

@property(nonatomic,assign)int  code;
@property(nonatomic,strong)NSMutableArray * messages;
@property(nonatomic,strong)ImageDataModel * data;

@end
