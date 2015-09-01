//
//  ForumPicViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/18.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "DSXUtil.h"
#import "ForumPicViewCell.h"

@interface ForumPicViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{
    @private
    int _page;
    UIRefreshControl *_refreshControl;
    UILabel *_footerView;
    BOOL _showLoadMore;
    BOOL _isRefreshing;
}

@property(nonatomic,strong)NSMutableArray *piclist;
@property(nonatomic,retain)UITableView *mainTableView;
@property(nonatomic,retain)NSOperationQueue *operationQueue;

@end
