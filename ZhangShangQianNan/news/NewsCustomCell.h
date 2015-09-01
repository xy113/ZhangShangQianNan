//
//  NewsCustomCell.h
//  大师兄CMS
//
//  Created by songdewei on 15/8/10.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCustomCell : UITableViewCell

@property(nonatomic,strong)NSDictionary *cellData;
- (void)setCellForDictionary:(NSDictionary *)dict;
@end
