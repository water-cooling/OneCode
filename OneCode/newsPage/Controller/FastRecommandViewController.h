//
//  FastRecommandViewController.h
//  bihucj
//
//  Created by humengfan on 2018/8/1.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol shareImgResultDelegate<NSObject>


-(void)shareLinkResult:(BOOL)result AndCancel:(BOOL)cancel;

@end


@interface FastRecommandViewController : BaseViewController

@property(nonatomic,weak) id<shareImgResultDelegate>  delegate;

@property(nonatomic,copy)NSString *  ShareContent;
@property(nonatomic,copy)NSString *  ShareTime;
@property(nonatomic,copy)NSString *  ShareTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;



@end
