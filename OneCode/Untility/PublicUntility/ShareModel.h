//
//  ShareModel.h
//  bihucj
//
//  Created by humengfan on 2018/8/1.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

@property(nonatomic,copy)NSString *  ShareTitle;

@property(nonatomic,copy)NSString *  ShareContent;

@property(nonatomic,copy)NSString *  ShareUrl;



-(instancetype)initWithshareTitle:(NSString *)title ShareContent:(NSString *)content ShareUrl:(NSString *)url;
@end
