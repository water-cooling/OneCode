//
//  PicUpdate.h
//  FungusProject
//
//  Created by humengfan on 2018/5/27.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PicUpModel : NSObject

@property(nonatomic,assign)CGFloat heightPerWidth;
@property(nonatomic,copy)NSString *  url;

@end


@interface PicUpdataModel : NSObject

@property (nonatomic,assign)long long int time;
@property (nonatomic,strong) PicUpModel * response;


@end

@interface PicsUpModel : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) PicUpdataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end
