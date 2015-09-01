//
//  ForumPostViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/29.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DSXUserStatus;
@interface ForumPostViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate>{
    @private
    UIView *_mainView;
    CGRect _mainViewFrame;
    UILabel *_placeHolder;
}

@property(nonatomic,assign)NSInteger fid;
@property(nonatomic,retain)UITextField *subjectTextField;
@property(nonatomic,retain)UITextView *messageTextView;
@property(nonatomic,retain)UIButton *sendButton;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@end
