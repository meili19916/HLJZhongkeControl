//
//  HLJLoginPageViewController.m
//  HLJZhongkeControl_Example
//
//  Created by Juan on 2021/2/22.
//  Copyright © 2021 meili19916. All rights reserved.
//

#import "HLJLoginPageViewController.h"
#import "HLJHttp.h"
#import "UIView+Toast.h"

@interface HLJLoginPageViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *smsTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationButton;
@property (nonatomic,strong)     NSTimer *timer;
@property (nonatomic,assign)     NSInteger count;
@end

@implementation HLJLoginPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"登录";
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)getVerifycationButtonClicked:(id)sender {

     if (self.phoneTextField.text.length <= 0) {
           [self.view makeToast:@"请输入手机号" duration:2 position:CSToastPositionCenter];
           return;
       }

       self.verificationButton.enabled = NO;
       NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text,@"mobile",@"login",@"type",nil];

       [self.view makeToastActivity:CSToastPositionCenter];
       [[HLJHttp shared] sms:data success:^(NSDictionary *data) {
           [self.view hideToastActivity];
           self.count = 60;
           self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAdd) userInfo:nil repeats:YES];

       } failure:^(NSInteger code, NSString *error) {
           [self.view hideToastActivity];
           [self.view makeToast:error duration:2 position:CSToastPositionCenter];
           self.verificationButton.enabled = YES;
       }];
}

- (void)timerAdd{
    if (self.count == 0) {
        self.verificationButton.enabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    }else{
        self.count --;
        [self.verificationButton setTitle:[NSString stringWithFormat:@"%lds",(long)self.count] forState:UIControlStateDisabled];
    }
}

- (IBAction)loginButtonClicked:(id)sender {

    if (![self checkInput]) {
        return;
    }
    NSDictionary *data ;
        data = [NSDictionary dictionaryWithObjectsAndKeys:self.phoneTextField.text,@"mobile",self.smsTextField.text,@"pass",@0,@"type",nil];

    [self.view makeToastActivity:CSToastPositionCenter];
    [[HLJHttp shared] login:data success:^(NSDictionary *data) {
        [self.view hideToastActivity];
        [HLJHttp shared].user.token = data[@"token"];
        [HLJHttp shared].user.name = data[@"name"];
       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
       [userDefaults setObject:[[HLJHttp shared].user yy_modelToJSONString] forKey:@"userModel"];
       [userDefaults synchronize];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString *error) {
        [self.view makeToast:error duration:2 position:CSToastPositionCenter];
        [self.view hideToastActivity];
    }];
}
- (BOOL)checkInput{
    if (self.phoneTextField.text.length <= 0) {
        [self.view makeToast:@"请输入手机号" duration:2 position:CSToastPositionCenter];
        return NO;
    }
    if (self.smsTextField.text.length <= 0) {
        [self.view makeToast:@"请输入密码" duration:2 position:CSToastPositionCenter];
        return NO;
    }
    return YES;
}


@end
