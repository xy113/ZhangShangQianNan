//
//  NewsListViewController.h
//  大师兄CMS
//
//  Created by songdewei on 15/8/13.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "DSXUtil.h"
#import "ShowNewsDetailDelegate.h"
#import "NewsScrollBar.h"

@interface NewsListViewController : UIViewController<UIScrollViewDelegate,ShowNewsDetailDelegate,MenuButtonDelegate>

@property(nonatomic,retain)NewsScrollBar *scrollBar;
@property(nonatomic,retain)UIScrollView *mainScrollView;

@end