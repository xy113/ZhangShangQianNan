//
//  DSXUtil.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "DSXUtil.h"

@implementation DSXUtil

+ (instancetype)sharedUtil{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (NSData *)dataWithURL:(NSString *)urlString{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (data) {
        return data;
    }else {
        return nil;
    }
}

- (NSData *)sendDataForURL:(NSString *)urlString params:(NSMutableDictionary *)params{
    NSString *postString = @"";
    for (NSString *key in [params allKeys]) {
        NSString *value = [params objectForKey:key];
        postString = [postString stringByAppendingFormat:@"%@=%@&",key,value];
    }
    if (postString.length > 0) {
        postString = [postString substringToIndex:postString.length-1];
    }
    NSError *error;
    NSURLResponse *urlResponse;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
}

- (void)shareWithView:(UIView *)view params:(NSDictionary *)params{
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:[params objectForKey:@"content"]
                                       defaultContent:@"掌上黔南"
                                                image:[ShareSDK imageWithUrl:[params objectForKey:@"image"]]
                                                title:[params objectForKey:@"title"]
                                                  url:[params objectForKey:@"url"]
                                          description:[params objectForKey:@"description"]
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:view arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)showWindowInView:(UIView *)view Image:(NSString *)image Size:(CGSize)size Message:(NSString *)message{
    UIView *window = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((size.width - 32)/2, 10, 32, 32)];
    [imageView setImage:[UIImage imageNamed:image]];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [window addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 48, size.width, 20)];
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.0f];
    label.numberOfLines = 2;
    
    CGPoint center = view.center;
    center.y = center.y - 50;
    [window addSubview:label];
    [window setBackgroundColor:[UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.00]];
    //[window setAlpha:0.6];
    window.layer.cornerRadius = 5.00;
    window.layer.masksToBounds = YES;
    window.center = center;
    [view addSubview:window];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:window forKey:@"window"];
    [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(hideWindow:) userInfo:userInfo repeats:NO];
}

- (void)hideWindow:(id)timer{
    UIView *window = [[timer userInfo] objectForKey:@"window"];
    [window removeFromSuperview];
}

- (void)successWindowInView:(UIView *)view Size:(CGSize)size Message:(NSString *)message{
    [self showWindowInView:view Image:@"icon-success.png" Size:size Message:message];
}

- (void)wrongWindowInView:(UIView *)view Size:(CGSize)size Message:(NSString *)message{
    [self showWindowInView:view Image:@"icon-wrong.png" Size:size Message:message];
}

- (void)informationWindowInView:(UIView *)view Size:(CGSize)size Message:(NSString *)message{
    [self showWindowInView:view Image:@"icon-information.png" Size:size Message:message];
}

- (UIView *)waitingWindowInView:(UIView *)view Size:(CGSize)size Message:(NSString *)message{
    CGPoint center = view.center;
    center.y = center.y - 50;
    UIView *window = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    window.center = center;
    window.backgroundColor = [UIColor blackColor];
    window.layer.cornerRadius = 5.0;
    window.layer.masksToBounds = YES;
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((size.width-40)/2, 10, 40, 40)];
    [indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [window addSubview:indicator];
    [indicator startAnimating];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, size.width-20, 20)];
    label.text = message;
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [window addSubview:label];
    [view addSubview:window];
    return window;
}

+ (void)closeWindow:(UIView *)window{
    [window removeFromSuperview];
}

@end
