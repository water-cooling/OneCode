//
//  UpImgUntility.m
//  bihucj
//
//  Created by humengfan on 2018/7/29.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "UpImgUntility.h"
#import <MJExtension.h>
#import <AFNetworking.h>
@implementation UpImgUntility

+(void)UpdataImg:(UIImage * )Img callback:(void(^)(PicUpModel * picup,FGError *error))block{
    

    NSString * url = [bihucjUrl stringByAppendingString:@"api/comm/file/uploadFile"];

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formormat = [[NSDateFormatter alloc]init];
        [formormat setDateFormat:@"HHmmss"];
        NSString *dateString = [formormat stringFromDate:date];
        
        NSString *fileName = [NSString  stringWithFormat:@"%@.png",dateString];
        NSData *imageData = UIImageJPEGRepresentation(Img, 1);
        double scaleNum = (double)300*1024/imageData.length;
        NSLog(@"图片压缩率：%f",scaleNum);
        
        if(scaleNum <1){
            
            imageData = UIImageJPEGRepresentation(Img, scaleNum);
        }else{
            
            imageData = UIImageJPEGRepresentation(Img, 0.1);
            
        }
        
        [formData  appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        NSLog(@"---%@",uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        PicsUpModel* pics = [PicsUpModel mj_objectWithKeyValues:responseObject];
        
        if (pics.code == 200) {
            
            block(pics.data.response,nil);
            
        }else
        {
            
            block(nil,[FGError  ErrorCode:pics.code DescribeStr:[pics.messages[0]message]]);
            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        block(nil,[FGError  ErrorCode:error.code DescribeStr:@"上传图片错误"]);
        
        
    }];
    
}

@end
