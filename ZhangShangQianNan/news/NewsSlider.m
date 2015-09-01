//
//  DSXSlider.m
//  大师兄CMS
//
//  Created by songdewei on 15/8/13.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsSlider.h"
#import "UIImageView+WebCache.h"

@implementation NewsSlider
@synthesize slideArray;
@synthesize slideView;
@synthesize pageControl;
@synthesize showDelegate;

- (instancetype)initWithFrame:(CGRect)frame andData:(NSArray *)data{
    self = [super initWithFrame:frame];
    if (self) {
        _width  = self.frame.size.width;
        _height = self.frame.size.height;
        self.slideArray = data;
        [self setScrollView];
    }
    return self;
}

- (void)setScrollView{
    self.slideView = [[UIScrollView alloc] initWithFrame:self.frame];
    self.slideView.delegate = self;
    self.slideView.pagingEnabled = YES;
    self.slideView.showsHorizontalScrollIndicator = NO;
    self.slideView.contentSize = CGSizeMake(_width*[self.slideArray count], 0);
    [self addSubview:self.slideView];
    [self setImage];
    [self setPageControl];
}
- (void)setImage{
    if ([self.slideArray count]>0) {
        for (int i=0; i<[self.slideArray count]; i++) {
            NSDictionary *item = self.slideArray[i];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_width*i, 0, _width, _height)];
            imageView.tag = [[item objectForKey:@"aid"] intValue];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[item objectForKey:@"image"]]];
            [imageView setContentMode:UIViewContentModeScaleToFill];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage:)];
            imageView.userInteractionEnabled = YES;
            [imageView addGestureRecognizer:singleTap];
            [self.slideView addSubview:imageView];
            
            UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, _height-40, _width, 40)];
            titleView.text = [item objectForKey:@"title"];
            titleView.textAlignment = NSTextAlignmentCenter;
            titleView.font = [UIFont systemFontOfSize:14.0];
            titleView.alpha = 0.5;
            titleView.backgroundColor = [UIColor blackColor];
            titleView.textColor = [UIColor whiteColor];
            [imageView addSubview:titleView];
        }
    }
}

- (void)clickImage:(id)sender{
    UITapGestureRecognizer *tap = (UITapGestureRecognizer *)sender;
    NSInteger newsID = tap.view.tag;
    [self.showDelegate showNewsDetailWithID:newsID];
}

- (void)setPageControl{
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(_width-100, _height-20, 100, 20)];
    self.pageControl.numberOfPages = [self.slideArray count];
    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(swithPage:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageControl];
}

- (void)swithPage:(id)sender{
    UIPageControl *currentControl = (UIPageControl *)sender;
    NSInteger currentPage = currentControl.currentPage;
    [self.slideView setContentOffset:CGPointMake(_width*currentPage, 0) animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;{
    if (scrollView == self.slideView) {
        NSInteger currentPage = self.slideView.contentOffset.x/_width;
        [self.pageControl setCurrentPage:currentPage];
    }
}

@end