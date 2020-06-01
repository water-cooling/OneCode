//
//  ShareModel.m
//  bihucj
//
//  Created by humengfan on 2018/8/1.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "ShareModel.h"

@implementation ShareModel

- (instancetype)initWithshareTitle:(NSString *)title ShareContent:(NSString *)content ShareUrl:(NSString *)url
{
    if (self = [super init]) {
        
        self.ShareTitle = title;
        self.ShareContent = content;
        self.ShareUrl = url;
    }
    return self;
}
@end
