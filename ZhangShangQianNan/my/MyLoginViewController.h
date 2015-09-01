//
//  MyLoginViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/24.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyLoginViewController : UIViewController<UITextFieldDelegate>

@property(nonatomic,retain)UITextField *usernameField;
@property(nonatomic,retain)UITextField *passwordField;
@end
