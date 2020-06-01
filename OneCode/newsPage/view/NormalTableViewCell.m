//
//  NormalTableViewCell.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#define LineColor  [UIColor colorWithHexString:@"#FFC41A"]

#import "NormalTableViewCell.h"


@implementation NormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)drawRect:(CGRect)rect{

    CGFloat contest = self.BottomHeight.constant;
    
    CGContextRef context=UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, LineColor.CGColor);//设置线的颜色
    
    CGContextMoveToPoint(context,15,contest);//画线的起始点位置
    
    CGContextAddLineToPoint(context,15,19+ contest);//画第一条线的终点位置
    
    // 绘制图片
    
    UIImage *image = [UIImage imageNamed:@"时间点"];
    
    [image drawInRect:CGRectMake(11, 19 +contest, 9, 9)];//在坐标中画出图片
    
    
    CGContextMoveToPoint(context,15,28 +contest);//画线的起始点位置
    
    CGContextAddLineToPoint(context,15,self.height);//画第一条线的终点位置
    
    CGContextStrokePath(context);//把线在界面上绘制出来
    
    
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
