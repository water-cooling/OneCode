//
//  EditPwdViewController.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "EditPwdViewController.h"
#import "ShowCodeVC.h"
#import "UserUtility.h"
#import "ViewControllerUtility.h"
#import "PredicateUtility.h"
@interface EditPwdViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *CodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *PwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *IPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *CodetextField;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;

@property (weak, nonatomic) IBOutlet UILabel *ShowLab;
@end

@implementation EditPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _PwdTextField.delegate = self;
    _PwdTextField.secureTextEntry = YES;
    UIView *RightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 14)];
    UIButton * eyesBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [eyesBtn setImage:[UIImage imageNamed:@"不可见"] forState:UIControlStateNormal];
    [eyesBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateSelected];
    
    eyesBtn.frame = CGRectMake(0, 0, 20, 14);
    [RightView addSubview:eyesBtn];
    UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [clearButton setImage:[UIImage imageNamed:@"删除"] forState:UIControlStateNormal];
    clearButton.frame = CGRectMake(41*iPhonescale, 0, 14, 14);
    [clearButton addTarget:self action:@selector(cleantextfield) forControlEvents:UIControlEventTouchUpInside];
    [eyesBtn addTarget:self action:@selector(ShowPwd:) forControlEvents:UIControlEventTouchUpInside];
    
    [RightView addSubview:clearButton];
    _PwdTextField.rightView = RightView;
    _PwdTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    self.title = @"找回密码";
}


#pragma textFieldDelegate


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField.secureTextEntry)
    {
        [textField insertText:self.PwdTextField.text];
    }
    
    
}


-(void)cleantextfield{
    
    self.PwdTextField.text = @"";
}

-(void)ShowPwd:(UIButton *)sender{
    
    [self.PwdTextField setSecureTextEntry:sender.selected];
    
    sender.selected = !sender.selected;
    NSString *text = self.PwdTextField.text;
    self.PwdTextField.text = @"";
    self.PwdTextField.text = text;
    if (self.PwdTextField.secureTextEntry)
    {
        [self.PwdTextField insertText:self.PwdTextField.text];
    }else
    {
        
        
        
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)RunCodeTime:(UIButton *)sender {
    
    if (self.IPhoneTextField.text == nil || [self.IPhoneTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入手机号码"];
        
        return;
    }
    
    if (![PredicateUtility checkTelNumber:self.IPhoneTextField.text]) {
        
        [MBManager showBriefAlert:@"请输入正确的手机号码"];
        
        return;
    }
    
    ShowCodeVC *vc = [[ShowCodeVC alloc]initWithNibName:@"ShowCodeVC" bundle:nil];
    
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    vc.definesPresentationContext = YES;
    self.CodeBtn.userInteractionEnabled = NO;
    vc.block = ^(BOOL state, NSString *ID, NSString *ImageValue) {
        self.CodeBtn.userInteractionEnabled = YES;
        
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
    
    [UserUtility SendCodeID:ID imgValue:value type:@"findPwd" mobile:self.IPhoneTextField.text callback:^(SucceedModel *succeed, FGError *error) {
        
        if (error == nil) {
            

            [MBManager showBriefAlert:@"您已经成功的获取到验证码"];
            
            
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
            
            
        }
        
        
    }];
    
}
    

- (IBAction)EditClick:(UIButton *)sender {
    
    
    if (self.IPhoneTextField.text == nil || [self.IPhoneTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入手机号码"];
        
        return;
    }
    
    if (self.CodetextField.text == nil || [self.CodetextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入验证码"];
        
        return;
    }
    
    
    if (self.PwdTextField.text == nil || [self.PwdTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入密码"];
        
        return;
    }
    
    [UserUtility EditPasswordCodeValue:self.CodetextField.text mobile:self.IPhoneTextField.text password:self.PwdTextField.text callback:^(SucceedModel *succeed, FGError *error) {
       
        if (!error) {
            
            [ShowStateView  showStateViewTitle:@"密码修改成功，请重新登陆" StateType:StateBottom autoClear:YES AutoclearClearTimer:2];
            
            [self.navigationController popViewControllerAnimated:YES];
        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
        }
        
        
    }];
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
