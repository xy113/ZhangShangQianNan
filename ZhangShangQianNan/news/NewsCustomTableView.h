//
//  NewsCustomTableView.h
//  大师兄CMS
//
//  Created by songdewei on 15/8/13.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowNewsDetailDelegate.h"

@interface NewsCustomTableView : UITableView<UITableViewDelegate,UITableViewDataSource>{
    @private
    int _page;
    CGFloat _width;
    CGFloat _height;
    NSString *_keyName;
    UIRefreshControl *_refreshControl;
    UILabel *_footerView;
    BOOL _isRefreshing;
    UIActivityIndicatorView *_waitingView;
}
@property(nonatomic,assign)int catid;
@property(nonatomic,retain)NSMutableArray *rows;
@property(nonatomic,assign)id<ShowNewsDetailDelegate> detailDelegate;
@property(nonatomic,retain)NSOperationQueue *operationQueue;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)show;
@end