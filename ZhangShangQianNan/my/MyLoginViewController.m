//
//  MyLoginViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/24.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//
#import "Config.h"
#import "MyLoginViewController.h"
#import "DSXUserStatus.h"
#import "DSXUtil.h"

@interface MyLoginViewController ()

@end

@implementation MyLoginViewController
@synthesize usernameField;
@synthesize passwordField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.23 green:0.27 blue:0.33 alpha:1.00];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 200)];
    //headerView.backgroundColor = [UIColor colorWithRed:0.39 green:0.53 blue:0.67 alpha:1.00];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH-60)/2, 50, 60, 60)];
    [imageView setImage:[UIImage imageNamed:@"icon-mywhite.png"]];
    [headerView addSubview:imageView];
    
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH-200)/2, 120, 200, 30)];
    loginLabel.text = @"登录掌上黔南";
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.font = [UIFont systemFontOfSize:18.0f weight:900];
    loginLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:loginLabel];
    [self.view addSubview:headerView];
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake((SWIDTH-260)/2, 220, 260, 45)];
    self.usernameField.delegate = self;
    self.usernameField.placeholder = @"用户名";
    self.usernameField.font = [UIFont systemFontOfSize:16.0 weight:600];
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.backgroundColor = [UIColor whiteColor];
    self.usernameField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.usernameField.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.usernameField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.usernameField];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake((SWIDTH-260)/2, 270, 260, 45)];
    self.passwordField.delegate = self;
    self.passwordField.placeholder = @"密码";
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.backgroundColor = [UIColor whiteColor];
    self.passwordField.secureTextEntry = YES;
    self.passwordField.font = [UIFont systemFontOfSize:16.0 weight:600];
    self.passwordField.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:self.passwordField];
    
    UIButton *loginButton = [[UIButton alloc] initWithFrame:CGRectMake((SWIDTH-260)/2, 325, 260, 45)];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"button-bg-red.png"] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(chkLogin) forControlEvents:UIControlEventTouchDown];
    loginButton.backgroundColor = [UIColor redColor];
    loginButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    loginButton.titleLabel.font = [UIFont systemFontOfSize:18.0 weight:900];
    loginButton.layer.cornerRadius = 5.0;
    loginButton.layer.masksToBounds = YES;
    [self.view addSubview:loginButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake((SWIDTH-260)/2, 420, 260, 45)];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    cancelButton.layer.borderWidth = 1.0;
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.layer.cornerRadius = 5.0;
    [cancelButton addTarget:self action:@selector(clickBack) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:cancelButton];
}

- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)chkLogin{
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    if (username.length>1 && password.length>5) {
        DSXUserStatus *userstatus = [[DSXUserStatus alloc] init];
        [userstatus loginWithName:username andPassword:password];
        if (userstatus.isLogined) {
            [self loginSucceed];
        }else{
            [self loginFailed];
        }
    }else {
        [[DSXUtil sharedUtil] wrongWindowInView:self.view Size:CGSizeMake(160, 80) Message:@"用户名和密码输入错误"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.view) {
        [self.view endEditing:YES];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginSucceed{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)loginFailed{
    [[DSXUtil sharedUtil] wrongWindowInView:self.view Size:CGSizeMake(160, 85) Message:@"用户名和密码不匹配"];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
