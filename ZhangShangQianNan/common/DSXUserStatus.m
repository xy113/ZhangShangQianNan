//
//  DSXUserStatus.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/25.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//
#import "Config.h"
#import "DSXUtil.h"
#import "DSXUserStatus.h"

@implementation DSXUserStatus
@synthesize isLogined;
@synthesize uid = _uid;
@synthesize username = _username;
@synthesize password = _password;
@synthesize email = _email;
@synthesize userpic = _userpic;
@synthesize avatar;
@synthesize delegate;

- (instancetype)init{
    self = [super init];
    if (self) {
        NSDictionary *userstatus = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"userstatus"];
        NSString *username = [userstatus objectForKey:@"username"];
        NSInteger uid = [[userstatus objectForKey:@"uid"] intValue];
        if (uid>0 && username) {
            self.isLogined = YES;
            self.uid = uid;
            self.username = username;
            self.email = [userstatus objectForKey:@"email"];
            self.password = [userstatus objectForKey:@"password"];
            self.userpic = [userstatus objectForKey:@"userpic"];
            self.avatar = [UIImage imageWithData:[userstatus objectForKey:@"avatar"]];
        }else{
            self.isLogined = NO;
            self.uid = -1;
            self.username = nil;
            self.email = nil;
            self.password = nil;
            self.userpic = nil;
            self.avatar = nil;
        }
    }
    return self;
}

+ (instancetype)sharedStatus{
    static dispatch_once_t once;
    static id instance = nil;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (NSDictionary *)loginWithName:(NSString *)username andPassword:(NSString *)password{
    if (username && password) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:username forKey:@"username"];
        [params setObject:password forKey:@"password"];
        NSData *data = [[DSXUtil sharedUtil] sendDataForURL:[SITEAPI stringByAppendingString:@"&mod=login"] params:params];
        if (data) {
            id ucresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([ucresult isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *userstatus = [NSMutableDictionary dictionaryWithDictionary:ucresult];
                NSString *username = [userstatus objectForKey:@"username"];
                NSInteger uid = [[userstatus objectForKey:@"uid"] intValue];
                NSURL *dataURL = [NSURL URLWithString:[userstatus objectForKey:@"userpic"]];
                [userstatus setObject:[NSData dataWithContentsOfURL:dataURL] forKey:@"avatar"];
                
                if (uid>0 && username) {
                    self.isLogined = YES;
                    self.uid = uid;
                    self.username = username;
                    self.email = [userstatus objectForKey:@"email"];
                    self.password = [userstatus objectForKey:@"password"];
                    self.userpic = [userstatus objectForKey:@"userpic"];
                }else{
                    self.isLogined = NO;
                    self.uid = -1;
                    self.username = nil;
                    self.email = nil;
                    self.password = nil;
                    self.userpic = nil;
                }
                [[NSUserDefaults standardUserDefaults] setObject:userstatus forKey:@"userstatus"];
                [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil userInfo:@{@"userstatus":self}];
                [delegate afterLogin];
                return userstatus;
            }else {
                return nil;
            }
            
        }else{
            return nil;
        }
    }else {
        return nil;
    }
}

- (void)logout{
    self.isLogined = NO;
    self.uid = -1;
    self.username = nil;
    self.email = nil;
    self.password = nil;
    self.userpic = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userstatus"];
    [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil userInfo:@{@"userstatus":self}];
    [delegate afterLogout];
}

@end
NSString *const UserStatusChangedNotification = @"UserStatusChangedNotification";