//
//  ResultTableViewCell.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "ResultTableViewCell.h"

@implementation ResultTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)MoreClick:(UIButton *)sender {
    
   
    [self.delegate MoreBtnClick:self.tag btnState:sender];

    
    
}
- (IBAction)ShareClick:(UIButton *)sender {
    
    [self.delegate ShareBtnClick:self.tag];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
