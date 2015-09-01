//
//  MyItemView.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/23.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "MyItemView.h"

@implementation MyItemView

- (void)setImage:(NSString *)image title:(NSString *)title{
    CGFloat width = self.frame.size.width;
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    [imageView setFrame:CGRectMake(width/2-15, 0, 30, 30)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:imageView];
    
    UILabel *textView = [[UILabel alloc] initWithFrame:CGRectMake(width/2-25, 32, 50, 20)];
    textView.text = title;
    textView.font = [UIFont systemFontOfSize:14.0f];
    textView.textAlignment = NSTextAlignmentCenter;
    textView.textColor = [UIColor blackColor];
    [self addSubview:textView];
    [self setBackgroundImage:[UIImage imageNamed:@"imageplaceholder.png"] forState:UIControlStateSelected];
}

@end
