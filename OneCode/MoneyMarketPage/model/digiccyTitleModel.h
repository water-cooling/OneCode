//
//  digiccyTitleModel.h
//  bihucj
//
//  Created by humengfan on 2018/9/13.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface digiccyTitledataModel : NSObject

@property (nonatomic,assign)long long int time;

@property (nonatomic,strong) NSMutableArray * response;


@end

@interface digiccyTitleModel : NSObject

@property (nonatomic,assign)int code;
@property (nonatomic,strong) digiccyTitledataModel * data;
@property (nonatomic,strong) NSMutableArray * messages;
@end
