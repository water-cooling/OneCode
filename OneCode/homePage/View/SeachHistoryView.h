//
//  dada.m
//  BCNCj
//
//  Created by humengfan on 2019/8/22.
//  Copyright © 2019 humengfan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HistoryDidSelectDelegate<NSObject>

-(void)didSelectIndexStr:(NSString *)Title;

-(void)DeleteHistoryData;

@end

@interface SeachHistoryView : UIView


@property(nonatomic,weak)id<HistoryDidSelectDelegate>delegate;


@property(nonatomic,strong)NSMutableArray *dataSource;



@end
