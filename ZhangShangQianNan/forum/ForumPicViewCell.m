//
//  ForumPicViewCell.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/18.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumPicViewCell.h"
#import "UIImageView+WebCache.h"

@implementation ForumPicViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCellForDictionary:(NSDictionary *)dict{
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    self.backgroundColor = [UIColor clearColor];
    _width = self.contentView.frame.size.width;
    _height = self.contentView.frame.size.height;
    _grayColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.00];
    for (UIView *subview in self.contentView.subviews) {
        [subview removeFromSuperview];
    }
    UIView *cellContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width, 275)];
    cellContentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:cellContentView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, _width, 200)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:nil];
    [imageView setContentMode:UIViewContentModeRedraw];
    [cellContentView addSubview:imageView];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 215, _width-20, 30)];
    titleView.text = [dict objectForKey:@"subject"];
    titleView.textColor = [UIColor blackColor];
    titleView.font = [UIFont systemFontOfSize:18.0 weight:800];
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    [cellContentView addSubview:titleView];
    
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 250, 100, 20)];
    authorLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"author"]];
    authorLabel.font = [UIFont systemFontOfSize:12.0f];
    authorLabel.textColor = _grayColor;
    [cellContentView addSubview:authorLabel];
    
    UIImageView *viewNumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-viewnum.png"]];
    viewNumIcon.frame = CGRectMake(_width-100, 252, 16, 16);
    [cellContentView addSubview:viewNumIcon];
    
    UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_width-80, 250, 40, 20)];
    viewsLabel.text = [dict objectForKey:@"views"];
    viewsLabel.font = [UIFont systemFontOfSize:12.0f];
    viewsLabel.textColor = _grayColor;
    viewsLabel.textAlignment = NSTextAlignmentLeft;
    [cellContentView addSubview:viewsLabel];
    
    UIImageView *commentNumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-commentnum.png"]];
    commentNumIcon.frame = CGRectMake(_width-50, 252, 16, 16);
    [cellContentView addSubview:commentNumIcon];
    
    UILabel *commentNumView = [[UILabel alloc] initWithFrame:CGRectMake(_width-30, 250, 30, 20)];
    commentNumView.text = [dict objectForKey:@"replies"];
    commentNumView.font = [UIFont systemFontOfSize:12.0f];
    commentNumView.textColor = _grayColor;
    commentNumView.textAlignment = NSTextAlignmentLeft;
    [cellContentView addSubview:commentNumView];
    
}

@end
