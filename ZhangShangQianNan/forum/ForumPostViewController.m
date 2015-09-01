//
//  ForumPostViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/29.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumPostViewController.h"
#import "DSXUIButton.h"
#import "Config.h"
#import "DSXUserStatus.h"
#import "DSXUtil.h"

@interface ForumPostViewController ()

@end

@implementation ForumPostViewController
@synthesize fid;
@synthesize subjectTextField;
@synthesize messageTextView;
@synthesize sendButton;
@synthesize userStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"发帖"];
    [self.view setBackgroundColor:GRAYBGCOLOR];
    self.userStatus = [[DSXUserStatus alloc] init];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(editDone)];
    
    _mainViewFrame = CGRectMake(10, 20, SWIDTH-20, 300);
    _mainView = [[UIView alloc] initWithFrame:_mainViewFrame];
    self.subjectTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, SWIDTH - 20, 40)];
    self.subjectTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.subjectTextField.placeholder = @"请输入主题";
    self.subjectTextField.returnKeyType = UIReturnKeyDone;
    self.subjectTextField.delegate = self;
    [_mainView addSubview:self.subjectTextField];
    
    self.messageTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 50, SWIDTH-20, 200)];
    self.messageTextView.font = [UIFont systemFontOfSize:16.0];
    self.messageTextView.layer.borderWidth = 0.6;
    self.messageTextView.layer.borderColor = [UIColor colorWithRed:0.70 green:0.70 blue:0.70 alpha:1.00].CGColor;
    self.messageTextView.layer.cornerRadius = 5.0;
    self.messageTextView.layer.masksToBounds = YES;
    self.messageTextView.backgroundColor = [UIColor whiteColor];
    self.messageTextView.delegate = self;
    self.messageTextView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.messageTextView.scrollEnabled = NO;
    [_mainView addSubview:self.messageTextView];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SWIDTH, 30)];
    _placeHolder.text = @"请输入内容";
    _placeHolder.font = [UIFont systemFontOfSize:16.0];
    _placeHolder.textColor = [UIColor grayColor];
    [self.messageTextView addSubview:_placeHolder];
    
    self.sendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, SWIDTH - 20, 50)];
    [self.sendButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.sendButton setBackgroundColor:[UIColor redColor]];
    [self.sendButton setBackgroundImage:[UIImage imageNamed:@"button-bg-red.png"] forState:UIControlStateHighlighted];
    [self.sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.sendButton.layer.cornerRadius = 5.0;
    self.sendButton.layer.masksToBounds = YES;
    self.sendButton.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:500];
    [self.sendButton addTarget:self action:@selector(publish) forControlEvents:UIControlEventTouchDown];
    [_mainView addSubview:self.sendButton];
    [self.view addSubview:_mainView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editDone{
    [self.view endEditing:YES];
}

- (void)publish{
    NSString *subject = self.subjectTextField.text;
    NSString *message = self.messageTextView.text;
    if (subject.length < 2) {
        [[DSXUtil sharedUtil] wrongWindowInView:_mainView Size:CGSizeMake(180, 90) Message:@"帖子主题不能少于2个字"];
        return;
    }
    if (message.length < 5) {
        [[DSXUtil sharedUtil] wrongWindowInView:_mainView Size:CGSizeMake(180, 90) Message:@"帖子内容不能少于5个字"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@(self.userStatus.uid) forKey:@"uid"];
    [params setObject:self.userStatus.username forKey:@"username"];
    [params setObject:@(self.fid) forKey:@"fid"];
    [params setObject:subject forKey:@"subject"];
    [params setObject:message forKey:@"message"];
    NSData *returns = [[DSXUtil sharedUtil] sendDataForURL:[SITEAPI stringByAppendingString:@"&mod=forummisc&ac=post"] params:params];
    //NSLog(@"%@",[[NSString alloc] initWithData:returns encoding:NSUTF8StringEncoding]);
    if ([returns length] > 0) {
        [[DSXUtil sharedUtil] successWindowInView:_mainView Size:CGSizeMake(120, 80) Message:@"发布成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"postSuccess" object:nil];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(clickBack) userInfo:nil repeats:NO];
    }else {
        [[DSXUtil sharedUtil] wrongWindowInView:_mainView Size:CGSizeMake(120, 90) Message:@"发布失败"];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    if (touch.view == self.view) {
        [self.view endEditing:YES];
    }
}


#pragma mark - 
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        _placeHolder.hidden = YES;
    }else{
        _placeHolder.hidden = NO;
    }
}

- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([self.messageTextView isFirstResponder]) {
        CGRect newFrame = _mainView.frame;
        newFrame.origin.y = SHEIGHT - frame.size.height - 250;
        _mainView.frame = newFrame;
    }
}

- (void)keyboardWillHide:(NSNotification *)notification{
    _mainView.frame = _mainViewFrame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
