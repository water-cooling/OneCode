//
//  AboutViewController.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "AboutViewController.h"
#import "AboutUntility.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AboutViewController ()

@property (weak, nonatomic) IBOutlet UILabel *ContentLab;
@property (weak, nonatomic) IBOutlet UIImageView *Img;
@property (weak, nonatomic) IBOutlet UILabel *AppLevel;

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于我们";
    [AboutUntility GetAboutcallback:^(AboutModel *about, FGError *error) {
       
        if (!error) {
            
            self.AppLevel.text = about.verson;
            
            [self.Img sd_setImageWithURL:[NSURL URLWithString:about.weIconUrl]];
            
            NSString * NewStr = [[NSString stringWithFormat:@"商务合作：%@\n建议反馈：%@\n投稿报道：%@\n客服微信：%@",about.busineCooperate,about.contribute,about.feedback,about.suppertWeChat] stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:NewStr];
            
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            
            [paragraphStyle setLineSpacing:10];//调整行间距
            
            
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [NewStr length])];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:13] range:NSMakeRange(0, NewStr.length)];
            [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1A1A1A"] range:NSMakeRange(0, NewStr.length)];
            
            self.ContentLab.attributedText = attributedString;
        }
        
    }];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
