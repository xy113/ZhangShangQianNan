//
//  NewsCustomCell.m
//  大师兄CMS
//
//  Created by songdewei on 15/8/10.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsCustomCell.h"
#import "UIImageView+WebCache.h"

@implementation NewsCustomCell
@synthesize cellData;

- (void)setCellForDictionary:(NSDictionary *)dict{
    //NSLog(@"%@",dict);
    self.cellData = dict;
    [self drawImageView];
    [self drawTitleView];
    [self drawAttrView];
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void)drawImageView{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 80, 60)];
    [imageView sd_setImageWithURL:[self.cellData objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"imageplaceholder.png"]];
    [self.contentView addSubview:imageView];
}


- (void)drawTitleView{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(98, 10, self.contentView.frame.size.width-98, 50)];
    titleView.text = [self.cellData objectForKey:@"title"];
    titleView.font = [UIFont systemFontOfSize:16.0f];
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5);
    titleView.numberOfLines = 2;
    titleView.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
    [titleView sizeToFit];
    [self.contentView addSubview:titleView];
}

- (void)drawAttrView{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(98, 53, 220, 20)];
    label.text = [self.cellData objectForKey:@"dateline"];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textColor = [UIColor grayColor];
    label.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 0);
    label.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.contentView addSubview:label];
    
    UIView *browseView = [[UIView alloc] initWithFrame:CGRectMake(self.contentView.frame.size.width-60, 53, 80, 20)];
    UIImageView *iconBrowse = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-browse-small.png"]];
    [iconBrowse setFrame:CGRectMake(0, 2, 16, 16)];
    iconBrowse.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    [browseView addSubview:iconBrowse];
    UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 60, 20)];
    viewsLabel.text = [[self.cellData objectForKey:@"viewnum"] stringValue];
    viewsLabel.textColor = [UIColor grayColor];
    viewsLabel.font = [UIFont systemFontOfSize:12.0f];
    [browseView addSubview:viewsLabel];
    [self.contentView addSubview:browseView];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
