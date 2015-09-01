//
//  Config.h
//  大师兄CMS
//
//  Created by songdewei on 15/8/12.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

//ShareSDK 接口配置
#define ShareAppName @"掌上黔南"
#define ShareAppKey @"9d158b5a6178"
#define ShareAppSecret @"59e46c696539877c9db235fae1a9253c"
//weibo 接口配置
#define WeiboAppName @"掌上黔南IPhone"
#define WeiboAPPKey @"496733533"
#define WeiboAPPSecret @"93dac2c207a1f6c02378ce41fceff0a8"

//屏幕尺寸
#define SWIDTH  self.view.frame.size.width
#define SHEIGHT self.view.frame.size.height
#define SCREENSIZE [UIScreen mainScreen].bounds.size
#define SCREENCENTER CGPointMake(SCREENSIZE.width/2, SCREENSIZE.height/2)

//网站接口地址
#define SITEAPI @"http://250854.com/app.php?appid=123456&appkey=123456"

//页面背景色
#define BACKGROUNDCOLOR [UIColor colorWithRed:0.91 green:0.91 blue:0.91 alpha:1.00]
#define WHITEBGCOLOR [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbg.png"]]
#define GRAYBGCOLOR  [UIColor colorWithPatternImage:[UIImage imageNamed:@"viewbg-gray.png"]]