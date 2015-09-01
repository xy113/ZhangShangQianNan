//
//  ForumDisplayCell.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumDisplayCell : UITableViewCell{
    @private
    CGFloat _width;
    CGFloat _height;
    UIColor *_grayColor;
}

@property(nonatomic,strong)NSDictionary *cellData;

- (void)setCellForDictionary:(NSDictionary *)dict;
@end
