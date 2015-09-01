//
//  ForumCollectionViewCell.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/16.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumCollectionViewCell.h"

@implementation ForumCollectionViewCell
@synthesize data;
- (void)setCellWithDictionary:(NSDictionary *)dict{
    self.data = dict;
    [self setCellImage];
    [self setCellTitle];
}
- (void)setCellImage{
    UIImage *image = [UIImage imageNamed:[self.data objectForKey:@"forumicon"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:CGRectMake((self.contentView.frame.size.width-60)/2, 10, 60, 60)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 30;
    [self.contentView addSubview:imageView];
}
- (void)setCellTitle{
    UITextView *titleView = [[UITextView alloc] initWithFrame:CGRectMake((self.contentView.frame.size.width-60)/2, 70, 60, 30)];
    titleView.text = [self.data objectForKey:@"forumtitle"];
    titleView.font = [UIFont systemFontOfSize:12.0f];
    titleView.editable = NO;
    titleView.scrollEnabled = NO;
    titleView.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:titleView];
}

@end
