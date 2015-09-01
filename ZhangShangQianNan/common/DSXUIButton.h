//
//  DSXUIButton.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/21.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

typedef enum{
    DSXBarButtonStyleBack,
    DSXBarButtonStyleShare,
    DSXBarButtonStyleLike,
    DSXBarButtonStyleFavor,
    DSXBarButtonStyleSearch,
    DSXBarButtonStyleAdd,
    DSXBarButtonStyleRefresh,
    DSXBarButtonStyleReply
}DSXBarButtonStyle;

#import <UIKit/UIKit.h>

@interface DSXUIButton : UIView

+ (instancetype)sharedButton;
- (UIBarButtonItem *)barButtonItemWithStyle:(DSXBarButtonStyle)style target:(id)target action:(SEL)selector;
- (UIBarButtonItem *)barButtonItemWithImage:(NSString *)imageName target:(id)target action:(SEL)selector;


@end
