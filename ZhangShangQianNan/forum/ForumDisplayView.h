//
//  ForumDisplayView.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ForumDisplayDelegate <NSObject>

- (void)cellDidSelected:(NSInteger)tid;

@end

@interface ForumDisplayView : UITableView<UITableViewDelegate,UITableViewDataSource>{
    @private
    int _page;
    CGFloat _width;
    CGFloat _height;
    NSString *_keyName;
    UIRefreshControl *_refreshControl;
    UILabel *_footerView;
    BOOL _isRefreshing;
}

@property(nonatomic,strong)NSString *filter;
@property(nonatomic,strong)NSMutableArray *rows;
@property(nonatomic,retain)NSOperationQueue *operationQueue;
@property(nonatomic,assign)id<ForumDisplayDelegate> viewThreadDelegate;

- (void)show;

@end
