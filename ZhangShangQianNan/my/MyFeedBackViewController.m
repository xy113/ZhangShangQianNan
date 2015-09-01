//
//  MyFeedBackViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/24.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//
#import "Config.h"
#import "DSXUIButton.h"
#import "DSXUtil.h"
#import "MyFeedBackViewController.h"
#import "DSXUserStatus.h"

@interface MyFeedBackViewController ()

@end

@implementation MyFeedBackViewController
@synthesize textView = _textView;
@synthesize userStatus;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"反馈给掌上黔南"];
    [self.view setBackgroundColor:GRAYBGCOLOR];
    [self.navigationController setNavigationBarHidden:NO];
    self.userStatus = [[DSXUserStatus alloc] init];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.frame];
    self.textView.delegate = self;
    self.textView.scrollEnabled = NO;
    self.textView.font = [UIFont systemFontOfSize:16.0f];
    self.textView.textColor = [UIColor blackColor];
    self.textView.textContainerInset = UIEdgeInsetsMake(10, 5, 5, 5);
    self.textView.backgroundColor = GRAYBGCOLOR;
    [self.textView becomeFirstResponder];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
    _placeHolder.text = @"请输入反馈意见";
    _placeHolder.textColor = [UIColor grayColor];
    _placeHolder.font = [UIFont systemFontOfSize:16.0f];
    [_placeHolder sizeToFit];
    [self.textView addSubview:_placeHolder];

    [self.view addSubview:self.textView];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send{
    [self.textView resignFirstResponder];
    NSString *message = self.textView.text;
    if (message.length > 2) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(self.userStatus.uid) forKey:@"uid"];
        [params setObject:self.userStatus.username forKey:@"username"];
        [params setObject:message forKey:@"message"];
        NSData *returns = [[DSXUtil sharedUtil] sendDataForURL:[SITEAPI stringByAppendingString:@"&mod=feedback"] params:params];
        if (returns) {
            [[DSXUtil sharedUtil] successWindowInView:self.textView Size:CGSizeMake(100, 80) Message:@"发送成功"];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(clickBack) userInfo:nil repeats:NO];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.textView.text.length > 0) {
        _placeHolder.hidden = YES;
    }else {
        _placeHolder.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
