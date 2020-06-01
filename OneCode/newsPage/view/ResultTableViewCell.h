//
//  ResultTableViewCell.h
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResultCellClickDelegate<NSObject>

-(void)MoreBtnClick:(NSInteger)SelectIndex btnState:(UIButton *)Sender;


-(void)ShareBtnClick:(NSInteger)SelectIndex;

@end


@interface ResultTableViewCell : UITableViewCell

@property(weak,nonatomic) id<ResultCellClickDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *ContentLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UIButton *ShareBtn;
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property (weak, nonatomic) IBOutlet UIButton *MoreBtn;

@end
