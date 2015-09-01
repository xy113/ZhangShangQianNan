//
//  ShowNewsDetailDelegate.h
//  大师兄CMS
//
//  Created by songdewei on 15/8/14.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

@protocol ShowNewsDetailDelegate <NSObject>
@required
- (void)showNewsDetailWithID:(NSInteger)newsID;

@end
