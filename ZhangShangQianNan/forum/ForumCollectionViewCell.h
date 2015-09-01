//
//  ForumCollectionViewCell.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/16.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForumCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)NSDictionary *data;

- (void)setCellWithDictionary:(NSDictionary *)dict;
- (void)setCellImage;
- (void)setCellTitle;
@end
