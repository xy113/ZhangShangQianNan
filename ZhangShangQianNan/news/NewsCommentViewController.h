//
//  NewsCommentViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/28.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCommentViewController : UITableViewController<UIScrollViewDelegate>{
    @private
    int _page;
    UIRefreshControl *_refreshControl;
    UILabel *_footerView;
    UILabel *_label;
    BOOL _isLoadMore;
    BOOL _isRefreshing;
}

@property(nonatomic,assign)NSInteger aid;
@property(nonatomic,retain)NSMutableArray *commentList;
@property(nonatomic,retain)NSOperationQueue *operationQueue;
@end
