//
//  DSXUIButton.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/21.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "DSXUIButton.h"

@implementation DSXUIButton

+ (instancetype)sharedButton{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (UIBarButtonItem *)barButtonItemWithStyle:(DSXBarButtonStyle)style target:(id)target action:(SEL)selector{
    NSString *imageName;
    switch (style) {
        case DSXBarButtonStyleShare:
            imageName = @"icon-share.png";
            break;
        case DSXBarButtonStyleFavor:
            imageName = @"icon-favor.png";
            break;
        case DSXBarButtonStyleBack:
            imageName = @"icon-goback.png";
            break;
        case DSXBarButtonStyleLike:
            imageName = @"icon-like.png";
            break;
        case DSXBarButtonStyleSearch:
            imageName = @"icon-search.png";
            break;
        case DSXBarButtonStyleRefresh:
            imageName = @"icon-refresh.png";
            break;
        case DSXBarButtonStyleAdd:
            imageName = @"icon-add.png";
            break;
        case DSXBarButtonStyleReply:
            imageName = @"icon-reply.png";
            break;
        default: imageName = nil;
            break;
    }
    return [self barButtonItemWithImage:imageName target:target action:selector];
}

- (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName target:(id)target action:(SEL)selector{
    UIImage *image = [[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:target action:selector];
    return barButtonItem;
}


@end
