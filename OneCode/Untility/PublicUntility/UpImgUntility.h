//
//  UpImgUntility.h
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FGError.h"
#include "PicUpModel.h"

@interface UpImgUntility : NSObject


+(void)UpdataImg:(UIImage * )Img callback:(void(^)(PicUpModel * picup,FGError *error))block;
@end
