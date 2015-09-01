//
//  MyFeedBackViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/24.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DSXUserStatus;
@interface MyFeedBackViewController : UIViewController<UITextViewDelegate>{
    @private
    UILabel *_placeHolder;
}
@property(nonatomic,retain)UITextView *textView;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@end
