//
//  ForumReplyViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/30.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSXUserStatus;
@interface ForumReplyViewController : UIViewController<UITextViewDelegate>{
    UITextView *_messageTextView;
    UILabel *_placeHolder;
}

@property(nonatomic,assign)NSInteger tid;
@property(nonatomic,assign)NSInteger fid;
@property(nonatomic,retain)DSXUserStatus *userStatus;

@end
