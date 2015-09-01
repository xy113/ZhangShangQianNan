//
//  ForumPicViewCell.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/18.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumPicViewCell : UITableViewCell{
@private
    CGFloat _width;
    CGFloat _height;
    UIColor *_grayColor;
}

- (void)setCellForDictionary:(NSDictionary *)dict;

@end
