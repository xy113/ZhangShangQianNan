//
//  DSXControl.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/29.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXControl.h"

@implementation DSXControl

+ (instancetype)sharedControl{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}
- (UIRefreshControl *)refreshControlWithTarget:(id)target action:(SEL)selector{
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [refreshControl addTarget:target action:selector forControlEvents:UIControlEventValueChanged];
    return refreshControl;
}

- (UILabel *)pullUpViewWithFrame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"上拉加载更多";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (UILabel *)tipsViewInView:(UIView *)view Message:(NSString *)message{
    UILabel *label = [[UILabel alloc] init];
    label.text = message;
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:14.0f];
    [label sizeToFit];
    [label setCenter:view.center];
    [view addSubview:label];
    return label;
}

@end
