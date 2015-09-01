//
//  NewsDetailViewController.h
//  大师兄CMS
//
//  Created by songdewei on 15/8/2.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "DSXUtil.h"
#import "DSXUIButton.h"
#import "DSXUserStatus.h"

@interface NewsDetailViewController : UIViewController<UIWebViewDelegate,UITextViewDelegate,UITextFieldDelegate>{
    @private
    UIActivityIndicatorView *_waitingView;
    UIButton *_refreshButton;
    NSInteger _refreshTimes;
    UIButton *_bottomButton;
    UILabel *_commentNum;
}
@property(nonatomic,assign)NSInteger newsID;
@property(nonatomic,strong)NSDictionary *article;
@property(nonatomic,retain)UIWebView *detailWebView;
@property(nonatomic,retain)UIView *maskView;
@property(nonatomic,retain)UIView *postView;
@property(nonatomic,retain)UITextView *commentTextView;
@property(nonatomic,retain)UIButton *commentSendButton;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@property(nonatomic,retain)NSOperationQueue *operationQueue;

@end