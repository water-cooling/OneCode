//
//  SignModel.h
//  bihucj
//
//  Created by humengfan on 2018/8/23.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SignResponseModel : NSObject

@property(nonatomic,assign)NSInteger  sginNum;
@property(nonatomic,assign)BOOL  todaySignIn;

@end


@interface SigndataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) SignResponseModel * response;


@end

@interface SignModel : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) SigndataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end

