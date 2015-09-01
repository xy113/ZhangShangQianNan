//
//  DSXControl.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/29.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DSXControl : NSObject

+ (instancetype)sharedControl;
- (UIRefreshControl *)refreshControlWithTarget:(id)target action:(SEL)selector;
- (UILabel *)pullUpViewWithFrame:(CGRect)frame;
- (UILabel *)tipsViewInView:(UIView *)view Message:(NSString *)message;

@end
