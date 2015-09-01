//
//  ForumReplyViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/30.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumReplyViewController.h"
#import "Config.h"
#import "DSXUtil.h"
#import "DSXUIButton.h"
#import "DSXUserStatus.h"

@interface ForumReplyViewController ()

@end

@implementation ForumReplyViewController
@synthesize tid;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = GRAYBGCOLOR;
    self.userStatus = [[DSXUserStatus alloc] init];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(send)];
    
    _messageTextView = [[UITextView alloc] initWithFrame:self.view.frame];
    _messageTextView.textColor = [UIColor blackColor];
    _messageTextView.font = [UIFont systemFontOfSize:16.0];
    _messageTextView.delegate = self;
    _messageTextView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _messageTextView.scrollEnabled = NO;
    [self.view addSubview:_messageTextView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [_messageTextView becomeFirstResponder];
    
    _placeHolder = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, SWIDTH, 30)];
    _placeHolder.text = @"请输入回复内容";
    _placeHolder.font = [UIFont systemFontOfSize:16.0];
    _placeHolder.textColor = [UIColor grayColor];
    [_messageTextView addSubview:_placeHolder];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)send{
    NSString *message = _messageTextView.text;
    if (message.length > 2) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(self.userStatus.uid) forKey:@"uid"];
        [params setObject:@(self.tid) forKey:@"tid"];
        [params setObject:@(self.fid) forKey:@"fid"];
        [params setObject:self.userStatus.username forKey:@"username"];
        [params setObject:message forKey:@"message"];
        [params setObject:@"IPhone 客户端" forKey:@"from"];
        NSData *data = [[DSXUtil sharedUtil] sendDataForURL:[SITEAPI stringByAppendingString:@"&mod=forummisc&ac=reply"] params:params];
        //NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        if ([data length] > 0) {
            [[DSXUtil sharedUtil] successWindowInView:_messageTextView Size:CGSizeMake(100, 90) Message:@"发送成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"replySuccess" object:nil];
            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(clickBack) userInfo:nil repeats:NO];
        }else {
            [[DSXUtil sharedUtil] wrongWindowInView:_messageTextView Size:CGSizeMake(100, 90) Message:@"发送失败"];
        }
    }else{
        [[DSXUtil sharedUtil] wrongWindowInView:_messageTextView Size:CGSizeMake(160, 90) Message:@"内容不能少于2个字"];
    }
}

- (void)keybardWillShow:(NSNotification *)notification{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if ([_messageTextView isFirstResponder]) {
        CGRect newFrame = _messageTextView.frame;
        newFrame.size.height = SHEIGHT - frame.size.height;
        _messageTextView.frame = newFrame;
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
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
