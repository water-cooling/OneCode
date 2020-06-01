//
//  EditIphoneViewController.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "EditIphoneViewController.h"
#import "ShowCodeVC.h"
#import "UserUtility.h"
#import "ViewControllerUtility.h"
#import "PredicateUtility.h"
@interface EditIphoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *IphoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *CodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *ShowLab;
@property (copy, nonatomic)  NSString * Codevalue;
@property (weak, nonatomic) IBOutlet UITextField *CodeTextField;

@end

@implementation EditIphoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改手机号";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)EditIphoneClick:(UIButton *)sender {
    
    
    if (self.IphoneTextField.text == nil || [self.IphoneTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入手机号码"];
        
        return;
    }
    
    if (self.CodeTextField.text == nil || [self.CodeTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入验证码"];
        
        return;
    }
    
    
    [UserUtility EditIphoneCodeValue:self.CodeTextField.text mobile:self.IphoneTextField.text callback:^(SucceedModel *succeed, FGError *error) {
       
        if (!error) {
            
            [ShowStateView  showStateViewTitle:@"手机号修改成功" StateType:StateBottom autoClear:YES AutoclearClearTimer:2];

            
            [[NSNotificationCenter defaultCenter]postNotificationName:LoginOut object:nil];
            
        }else
        {
            [MBManager showBriefAlert:error.descriptionStr];

        }
        
        self.ShowLab.hidden = NO;
    }];
}
- (IBAction)RunCodeTime:(UIButton *)sender {
    
    if (self.IphoneTextField.text == nil || [self.IphoneTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入手机号码"];
        
        return;
    }
    
    if (![PredicateUtility checkTelNumber:self.IphoneTextField.text]) {
        
        [MBManager showBriefAlert:@"请输入正确的手机号码"];
        
        return;
    }
    
    
    ShowCodeVC *vc = [[ShowCodeVC alloc]initWithNibName:@"ShowCodeVC" bundle:nil];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.definesPresentationContext = YES;
    self.CodeBtn.userInteractionEnabled = NO;
    vc.block = ^(BOOL state, NSString *ID, NSString *ImageValue) {
        
        if (state) {
            [self GetloadingCode:ID ImageValue:ImageValue];
            [self codeNumberRun];
            
        }else{
            
        }
    };
    [[ViewControllerUtility getRootViewController] presentViewController:vc animated:YES completion:nil];
}

-(void)codeNumberRun{
    
    __block NSInteger time = 59; //倒计时时间
    
    self.CodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#CCCACA"].CGColor;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            self.CodeBtn.userInteractionEnabled = YES;

            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.CodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
                [self.CodeBtn setTitleColor:[UIColor colorWithHexString:@"#1A1A1A"] forState:UIControlStateNormal];
                self.CodeBtn.layer.borderColor = [UIColor colorWithHexString:@"#333333"].CGColor;
                
                self.CodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.CodeBtn setTitle:[NSString stringWithFormat:@"%.0d后重新发送", seconds] forState:UIControlStateNormal];
                [self.CodeBtn setTitleColor:[UIColor colorWithHexString:@"#999999"] forState:UIControlStateNormal];
            });
            time--;
        }
    });
    dispatch_resume(_timer);
    
}


-(void)GetloadingCode:(NSString *)ID ImageValue:(NSString*)value{
    
    
    [UserUtility SendCodeID:ID imgValue:value type:@"band" mobile:self.IphoneTextField.text callback:^(SucceedModel *succeed, FGError *error) {
        
            if (error == nil) {
                
                [MBManager showBriefAlert:@"您已经成功的获取到验证码"];
                
                
            }else
            {
                
                [MBManager showBriefAlert:error.descriptionStr];
                
                
            }
            
            
        }];
        
    }
    
#pragma mark - Navigation

@end
