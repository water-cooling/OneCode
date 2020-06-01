//
//  ShareViewController.h
//  bihucj
//
//  Created by humengfan on 2018/8/22.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol shareLinkResultDelegate<NSObject>


-(void)shareLinkResult:(BOOL)result AndCancel:(BOOL)cancel;
;

@end


@interface OwnShareViewController : UIViewController


@property(nonatomic,weak) id<shareLinkResultDelegate>  delegate;


@property(nonatomic,copy) NSString *  shareLink;

@end
