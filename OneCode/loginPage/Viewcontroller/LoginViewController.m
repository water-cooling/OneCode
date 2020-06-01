//
//  LoginViewController.m
//  bihucj
//
//  Created by humengfan on 2018/7/19.
//  Copyright © 2018年 王师傅 Mac. All rights reserved.
//

#import "LoginViewController.h"
#import "UserUtility.h"
#import "PredicateUtility.h"
@interface LoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UITextField *PwdTextField;
@property (weak, nonatomic) IBOutlet UITextField *IphoneTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _PwdTextField.delegate = self;
    _PwdTextField.secureTextEntry = YES;
    self.scrollview.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    UIView *RightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 55, 14)];
    UIButton * eyesBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    [eyesBtn setImage:[UIImage imageNamed:@"不可见"] forState:UIControlStateNormal];
    [eyesBtn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateSelected];
    [eyesBtn addTarget:self action:@selector(ShowPwd:) forControlEvents:UIControlEventTouchUpInside];

    eyesBtn.frame = CGRectMake(0, 0, 20, 14);
    [RightView addSubview:eyesBtn];
    self.automaticallyAdjustsScrollViewInsets = NO;

    if (@available(iOS 11.0, *)) {
        if ([self.scrollview respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
            
            self.scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        

    }else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
    }
    
    _PwdTextField.rightView = RightView;
    _PwdTextField.rightViewMode = UITextFieldViewModeWhileEditing;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    if (textField.secureTextEntry)
    {
        [textField insertText:self.PwdTextField.text];
    }
    
    
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
- (IBAction)BackClick:(UIButton *)sender {
    
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)LoginClick:(UIButton *)sender {
    
    
    if (self.IphoneTextField.text == nil || [self.IphoneTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入手机号码"];

        return;
    }
    
    if (self.PwdTextField.text == nil || [self.PwdTextField.text isEqualToString:@""]) {
        
        [MBManager showBriefAlert:@"请输入密码"];
        
        return;
    }
    
    if (![PredicateUtility checkTelNumber:self.IphoneTextField.text]) {
        
        [MBManager showBriefAlert:@"请输入正确的手机号码"];
        
        return;
    }
    
    [UserUtility usernameSignIn:self.IphoneTextField.text password:self.PwdTextField.text callback:^(UserModel *user, FGError *error) {
       
        if (!error) {
            
            [MBManager showBriefAlert:@"登录成功"];
            
            
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:LoginIn object:nil];

        }else
        {
            
            [MBManager showBriefAlert:error.descriptionStr];
            
        }
        
        
    }];
    
    

    
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    
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
