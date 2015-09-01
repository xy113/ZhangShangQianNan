//
//  MyShowNotificationViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/27.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "MyShowNotificationViewController.h"
#import "Config.h"
#import "DSXUIButton.h"

@interface MyShowNotificationViewController ()

@end

@implementation MyShowNotificationViewController
@synthesize messageid;
@synthesize webView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"消息中心"];
    [self.view setBackgroundColor:WHITEBGCOLOR];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=my&ac=shownotification&id=%ld",(long)self.messageid];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
