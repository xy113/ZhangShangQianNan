//
//  ForumThreadViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXUIButton.h"
#import "DSXUtil.h"

@class DSXUserStatus;
@interface ForumThreadViewController : UIViewController<UIWebViewDelegate>{
    int _page;
    int _totalPage;
    UIView *_maskView;
    UIActivityIndicatorView *_waitingView;
    UIBarButtonItem *_prevButtonItem;
    UIBarButtonItem *_fixButtonItem;
    UIBarButtonItem *_pageButtonItem;
    UIBarButtonItem *_nextButtonItem;
}

@property(nonatomic,assign)NSInteger tid;
@property(nonatomic,retain)NSDictionary *thread;
@property(nonatomic,retain)UIWebView *threadWebView;
@property(nonatomic,retain)NSOperationQueue *operationQueue;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@end
