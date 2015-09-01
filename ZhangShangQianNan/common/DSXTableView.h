//
//  DSXTableView.h
//  ZhangShangQianNan
//
//  Created by songdewei on 15/8/31.
//  Copyright (c) 2015年 250854. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DSXTableViewDelegate <NSObject>
@required
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
@optional
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewStartRefreshing;
- (void)tableViewEndRefreshing;
- (void)tableViewRefreshedNothing;
- (void)tableViewStartLoading;
- (void)tableViewEndLoading;
- (void)tableViewLoadedNothing;

@end

@interface DSXTableView : UITableView<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>{

}

@property(nonatomic,strong)NSMutableArray *rows;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)BOOL isRefreshing;
@property(nonatomic,readonly,setter=setHeaderView:)UILabel *headerView;
@property(nonatomic,readonly,setter=setFooterView:)UILabel *footerView;
@property(nonatomic,readonly,setter=setWaitingView:)UIActivityIndicatorView *waitingView;
@property(nonatomic,readonly,setter=setRefreshControl:)UIRefreshControl *refreshControl;
@property(nonatomic,assign)id<DSXTableViewDelegate> tableViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)reloadTableViewWithData:(NSData *)data;
- (void)reloadTableViewWithArray:(NSArray *)array;
- (void)reloadEnd;

@end
