//
//  ForumDisplayCell.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumDisplayCell.h"

@implementation ForumDisplayCell

@synthesize cellData;

- (void)setCellForDictionary:(NSDictionary *)dict{
    self.cellData = dict;
    _width = self.contentView.frame.size.width;
    _height = self.contentView.frame.size.height;
    _grayColor = [UIColor colorWithRed:0.51 green:0.51 blue:0.51 alpha:1.00];
    [self drawTitleView];
    [self drawSubView];
}

- (void)drawTitleView{
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width-20, 50)];
    titleView.text = [self.cellData objectForKey:@"subject"];
    titleView.font = [UIFont systemFontOfSize:18.0f weight:600];
    titleView.numberOfLines = 2;
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
    [titleView sizeToFit];
    [self.contentView addSubview:titleView];
}
- (void)drawSubView{
    //UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(10, 60, self.contentView.frame.size.width-20, 20)];
    UILabel *authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 20)];
    authorLabel.text = [NSString stringWithFormat:@"%@",[self.cellData objectForKey:@"author"]];
    authorLabel.font = [UIFont systemFontOfSize:12.0f];
    authorLabel.textColor = _grayColor;
    [self.contentView addSubview:authorLabel];
    
    UIImageView *viewNumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-viewnum.png"]];
    viewNumIcon.frame = CGRectMake(_width-100, 62, 16, 16);
    [self.contentView addSubview:viewNumIcon];
    
    UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_width-80, 60, 40, 20)];
    viewsLabel.text = [self.cellData objectForKey:@"views"];
    viewsLabel.font = [UIFont systemFontOfSize:12.0f];
    viewsLabel.textColor = _grayColor;
    viewsLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:viewsLabel];
    
    UIImageView *commentNumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-commentnum.png"]];
    commentNumIcon.frame = CGRectMake(_width-50, 62, 16, 16);
    [self.contentView addSubview:commentNumIcon];
    
    UILabel *commentNumView = [[UILabel alloc] initWithFrame:CGRectMake(_width-30, 60, 30, 20)];
    commentNumView.text = [self.cellData objectForKey:@"replies"];
    commentNumView.font = [UIFont systemFontOfSize:12.0f];
    commentNumView.textColor = _grayColor;
    commentNumView.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:commentNumView];
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
