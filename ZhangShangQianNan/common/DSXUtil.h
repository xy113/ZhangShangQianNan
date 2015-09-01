//
//  DSXUtil.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import "WeiboSDK.h"

@interface DSXUtil : NSObject

+ (instancetype)sharedUtil;
- (NSData *)dataWithURL:(NSString *)urlString;
- (NSData *)sendDataForURL:(NSString *)urlString params:(NSDictionary *)params;
- (void)shareWithView:(UIView *)view params:(NSDictionary *)params;
- (void)successWindowInView:(UIView *)view Size:(CGSize)size Message:(NSString *)message;
- (void)wrongWindowInView:(UIView *)view Size:(CGSize)size Message:(NSString *)message;
- (void)informationWindowInView:(UIView *)view Size:(CGSize)size Message:(NSString *)message;
@end