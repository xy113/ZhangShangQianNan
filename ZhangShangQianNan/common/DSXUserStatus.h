//
//  DSXUserStatus.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/25.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@protocol UserStatusDelegate<NSObject>
@optional
- (void)afterLogin;
- (void)afterLogout;
@end


@interface DSXUserStatus : NSObject
@property(nonatomic,assign)BOOL isLogined;
@property(nonatomic,assign)NSInteger uid;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *password;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *userpic;
@property(nonatomic,retain)UIImage *avatar;
@property(nonatomic,strong)id<UserStatusDelegate> delegate;

- (instancetype)init;
+ (instancetype)sharedStatus;
- (NSDictionary *)loginWithName:(NSString *)username andPassword:(NSString *)password;
- (void)logout;
@end

UIKIT_EXTERN NSString *const UserStatusChangedNotification;