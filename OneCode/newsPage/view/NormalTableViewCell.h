//
//  NormalTableViewCell.h
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewsCellClickDelegate<NSObject>
-(void)MoreBtnClick:(NSInteger)SelectIndex btnState:(UIButton *)Sender;
-(void)ShareBtnClick:(NSInteger)SelectIndex;
@end
@interface NormalTableViewCell : UITableViewCell

@property(weak,nonatomic) id<NewsCellClickDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titlelab;
@property (weak, nonatomic) IBOutlet UILabel *Contentlab;
@property (weak, nonatomic) IBOutlet UILabel *TimeLab;
@property (weak, nonatomic) IBOutlet UIButton *Sharebtn;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *DesLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *BottomHeight;
@property (weak, nonatomic) IBOutlet UIButton *MoreBtn;

@end
