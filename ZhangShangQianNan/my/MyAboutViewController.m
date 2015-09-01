//
//  MyAboutViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/26.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "MyAboutViewController.h"
#import "DSXUIButton.h"
#import "Config.h"

@interface MyAboutViewController ()

@end

@implementation MyAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [self.view setBackgroundColor:WHITEBGCOLOR];
    [self setTitle:@"关于"];
    self.navigationItem.leftBarButtonItem =[[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((SWIDTH-200)/2, 80, 200, 59)];
    [imageView setImage:[UIImage imageNamed:@"logo.png"]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 200)/2, 146, 200, 30)];
    label.text = @"WWW.250854.COM";
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00];
    [self.view addSubview:label];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake((SWIDTH - 200)/2, 250, 200, 30)];
    version.text = @"Version 1.0";
    version.textColor = [UIColor blackColor];
    version.font = [UIFont systemFontOfSize:14.0f];
    version.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:version];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
