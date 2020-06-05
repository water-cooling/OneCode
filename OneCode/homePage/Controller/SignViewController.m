//
//  SignViewController.m
//  bihucj
//
//  Created by humengfan on 2018/8/21.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "SignViewController.h"
#import "SignUntility.h"
#import "UserUtility.h"


@interface SignViewController ()
@property (weak, nonatomic) IBOutlet UIView *showView;
@property(nonatomic,strong)NSMutableArray * SpeatorArr;
@property(nonatomic,strong)NSMutableArray * ClickArr;
@property(nonatomic,assign) NSInteger Select;
@property (nonatomic,strong)UIImageView * ShowStateImg;
@property (nonatomic,strong)UILabel * ShowLab;
@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.SpeatorArr = [NSMutableArray array];
    self.ClickArr = [NSMutableArray array];
    self.view.backgroundColor = [[UIColor colorWithHexString:@"#000000"]colorWithAlphaComponent:0.4];
    self.Select = 2;
    [self initUI];
    [self.view addSubview:self.ShowStateImg];
}
-(void)initUI{
    for (int i = 0; i< 7; i++) {
        UIButton * cornerbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIView  * speatorview = [UIView new];
        UILabel * bottomLab = [[UILabel alloc]init];
        [self.showView addSubview:cornerbtn];
        [self.showView addSubview:speatorview];
        [self.showView addSubview:bottomLab];
        
        [self.ClickArr addObject:cornerbtn];
        [self.SpeatorArr addObject:speatorview];

        speatorview.backgroundColor = [UIColor colorWithHexString:@"#CCCCCC"];

        SignListModel * model = self.ListModel.response[i];
        
        bottomLab.text = [NSString stringWithFormat:@"第%@天",model.day];
        
        bottomLab.textAlignment = NSTextAlignmentCenter;
        
        bottomLab.textColor = [UIColor colorWithHexString:@"#666666"];
        
        bottomLab.font =  [UIFont fontWithName:@"PingFang-SC-Medium" size:11];

        CGFloat btnx = 15 + (30 + 18)*i;
        
        [cornerbtn setTitle:[NSString stringWithFormat:@"+%@",model.pearlNum] forState:UIControlStateNormal];
        
        cornerbtn.layer.borderWidth = 1;
        
        
        cornerbtn.layer.cornerRadius = 15;
        
        cornerbtn.layer.masksToBounds = YES;
        
        cornerbtn.layer.borderColor = [UIColor colorWithHexString:@"##CCCCCC"].CGColor;

        [cornerbtn setTitleColor:[UIColor colorWithHexString:@"#B3B3B3"] forState:UIControlStateNormal];

        cornerbtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        
        [cornerbtn setBackgroundColor:[UIColor colorWithHexString:@"#F2F2F2"]];

        if ( i < 6) {
            
            CGFloat speatorx = 45 + (30 + 18)*i;

            speatorview.frame = CGRectMake(speatorx, 83, 18, 1);
        }
        cornerbtn.frame = CGRectMake(btnx, 68, 30, 30);
        
        bottomLab.frame = CGRectMake(cornerbtn.x,  CGRectGetMaxY(cornerbtn.frame) + 10, cornerbtn.width, 12);
        
    }
    if (self.stateModel) {
        
        [self changeValve];

    }
    
}
- (IBAction)DIsmiss:(UIControl *)sender {

    
    [self dismissViewControllerAnimated:YES completion:nil];


}


- (void)loginChangeUI:(SignResponseModel *)response{
    self.stateModel = response;
    [self changeValve];
    
}

-(void)changeValve{
    
    for (int i = 0; i < self.stateModel.sginNum; i++) {
        UIButton * cornerbtn = self.ClickArr[i];
        UILabel * speatorlab =   self.SpeatorArr[i];
        speatorlab.backgroundColor = [UIColor colorWithHexString:@"#F98040"];
        cornerbtn.layer.borderColor = [UIColor colorWithHexString:@"#F98040"].CGColor;
        [cornerbtn setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
        [cornerbtn setBackgroundColor:[UIColor colorWithHexString:@"#F98040"]];
      }
    if ( !self.stateModel.todaySignIn) {
        UIButton * cornerbtn = self.ClickArr[self.stateModel.sginNum];
        [cornerbtn setTitleColor:[UIColor colorWithHexString:@"#F98040"] forState:UIControlStateNormal];
        [cornerbtn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
        cornerbtn.layer.borderColor = [UIColor colorWithHexString:@"#F98040"].CGColor;
    }
    
}
- (IBAction)signNowclick:(UIButton *)sender {
    
    if ([UserUtility hasLogin]) {
    
    sender.userInteractionEnabled = NO;
    
    if (!self.stateModel.todaySignIn) {
        UIButton * btn =  self.ClickArr[self.stateModel.sginNum];
            [SignUntility SignClickcallback:^(SucceedModel *response, FGError *error) {
                sender.userInteractionEnabled = YES;
                if (!error) {
                    btn.backgroundColor = [UIColor colorWithHexString:@"#F98040"];
                    
                    [btn setTitleColor:[UIColor colorWithHexString:@"FFFFFF"] forState:UIControlStateNormal];
                    [self.showView removeFromSuperview];
                    
                    NSString * LabelText;
                    if (!response.signIn ) {
                        LabelText = response.shareArticle;
                        
                    }else{
                    
                        LabelText = [NSString stringWithFormat:@"恭喜你，今日签到成功 %@ 糖果",response.pearlNum];
                    }
                    
                    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:LabelText];
                    
                    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                    
                    paragraphStyle.alignment = NSTextAlignmentCenter;
                    
                    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [LabelText length])];
                    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang-SC-Regular" size:17] range:NSMakeRange(0, LabelText.length)];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1A1A1A"] range:NSMakeRange(0, LabelText.length)];
                    
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#F98040"] range: [LabelText rangeOfString:btn.titleLabel.text]];
                    
                    self.ShowLab.attributedText = attributedString;
                    
                    [self.ShowLab sizeToFit];
                    
                    [UIView animateWithDuration:0.3 animations:^{
                        
                        self.ShowStateImg.hidden = NO;
                        
                    }];
                    
                }else
                {
                    
                    [MBManager showBriefAlert:error.descriptionStr];
                    
                }
                
            }];
        }else{
            [MBManager showBriefAlert:@"当天您已经签到过了"];
        }
    }else  {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        BaseNavigationController *vc = [story instantiateViewControllerWithIdentifier:@"BaseNavigationController"];
        [self presentViewController:vc animated:YES completion:nil];
    }
}
-(UIImageView *)ShowStateImg{
    if(!_ShowStateImg){
        _ShowStateImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"签到成功"]];
        _ShowStateImg.frame = CGRectMake(48 , 203, 280, 279);
        self.ShowLab = [[UILabel alloc]initWithFrame:CGRectMake(60, 198, 169, 45)];
        self.ShowLab.preferredMaxLayoutWidth = 169;
        self.ShowLab.numberOfLines = 2;
        [_ShowStateImg addSubview:self.ShowLab];
        _ShowStateImg.hidden = YES;
    }
    
    return _ShowStateImg;
    
    
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
