//
//  DSXSlider.h
//  大师兄CMS
//
//  Created by songdewei on 15/8/13.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowNewsDetailDelegate.h"

@interface NewsSlider : UIView<UIScrollViewDelegate>{
    @private
    CGFloat _width;
    CGFloat _height;
}

@property(nonatomic,retain)NSArray *slideArray;
@property(nonatomic,retain)UIScrollView *slideView;
@property(nonatomic,retain)UIPageControl *pageControl;
@property(nonatomic,assign)id<ShowNewsDetailDelegate> showDelegate;

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)data;
- (void)setScrollView;
- (void)setImage;
- (void)setPageControl;

@end