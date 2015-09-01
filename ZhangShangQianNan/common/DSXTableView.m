//
//  DSXTableView.m
//  ZhangShangQianNan
//
//  Created by songdewei on 15/8/31.
//  Copyright (c) 2015年 250854. All rights reserved.
//

#import "DSXTableView.h"

@implementation DSXTableView
@synthesize rows;
@synthesize isRefreshing;
@synthesize headerView;
@synthesize footerView;
@synthesize waitingView;
@synthesize refreshControl;
@synthesize tableViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup{
    [self setRefreshControl:[[UIRefreshControl alloc] init]];
    [self.refreshControl setAttributedTitle:[[NSAttributedString alloc] initWithString:@"下拉刷新"]];
    [self.refreshControl addTarget:self action:@selector(refreshBegin) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.refreshControl = self.refreshControl;
    tableViewController.tableView = self;
    
    [self setFooterView:[[UILabel alloc] init]];
    self.footerView.hidden = YES;
    self.footerView.frame = CGRectMake(0, 0, self.frame.size.width, 60);
    self.footerView.text = @"上拉加载更多";
    self.footerView.font = [UIFont systemFontOfSize:14.0];
    self.footerView.textAlignment = NSTextAlignmentCenter;
    self.footerView.textColor = [UIColor grayColor];
    self.tableFooterView = self.footerView;
    
    [self setWaitingView:[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
    CGPoint center = self.center;
    center.y = center.y - 50;
    self.waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.waitingView.center = center;
    [self addSubview:self.waitingView];
    
    self.rows = [NSMutableArray array];
    self.delegate = self;
    self.dataSource = self;
}

- (void)refreshBegin{
    self.isRefreshing = YES;
    if ([self.tableViewDelegate respondsToSelector:@selector(tableViewStartRefreshing)]) {
        [self.tableViewDelegate tableViewStartRefreshing];
    }
}

- (void)reloadTableViewWithData:(NSData *)data{
    if ([data length] > 2) {
        id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            [self reloadTableViewWithArray:array];
        }
    }else {
        if (self.isRefreshing) {
            if ([self.tableViewDelegate respondsToSelector:@selector(tableViewRefreshedNothing)]) {
                [self.tableViewDelegate tableViewRefreshedNothing];
            }
        }else {
            if ([self.tableViewDelegate respondsToSelector:@selector(tableViewLoadedNothing)]) {
                [self.tableViewDelegate tableViewLoadedNothing];
            }
        }
        [self reloadEnd];
    }
}

- (void)reloadTableViewWithArray:(NSArray *)array{
    if ([array count] < self.pageSize) {
        self.footerView.hidden = YES;
    }else {
        self.footerView.hidden = NO;
    }
    if (self.isRefreshing) {
        [self.rows removeAllObjects];
        [self reloadData];
    }
    for (id item in array) {
        [self.rows addObject:item];
    }
    [self reloadData];
    [self reloadEnd];
}

- (void)reloadEnd{
    if (self.isRefreshing) {
        if ([self.tableViewDelegate respondsToSelector:@selector(tableViewEndRefreshing)]) {
            [self.tableViewDelegate tableViewEndRefreshing];
        }
    }else {
        if ([self.tableViewDelegate respondsToSelector:@selector(tableViewEndLoading)]) {
            [self.tableViewDelegate tableViewEndLoading];
        }
    }
    self.footerView.text = @"上拉加载更多..";
    if ([self.refreshControl isRefreshing]) {
        [self.refreshControl endRefreshing];
    }
    if ([self.waitingView isAnimating]) {
        [self.waitingView stopAnimating];
    }
    if (self.isRefreshing) {
        self.isRefreshing = NO;
    }
}

- (void)setRefreshControl:(UIRefreshControl *)newRefreshControl{
    refreshControl = newRefreshControl;
}

- (void)setHeaderView:(UILabel *)newHeaderView{
    headerView = newHeaderView;
}

- (void)setFooterView:(UILabel *)newFooterView{
    footerView = newFooterView;
}

- (void)setWaitingView:(UIActivityIndicatorView *)newWaitingView{
    waitingView = newWaitingView;
}

#pragma UITableView delegate
- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rows count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }else {
        return 50.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.tableViewDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)]) {
        [self.tableViewDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:shouldHighlightRowAtIndexPath:)]) {
        return [self.tableViewDelegate tableView:tableView shouldHighlightRowAtIndexPath:indexPath];
    }else {
        return YES;
    }
}


#pragma mark - UIScrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self) {
        if (self.contentOffset.y > (self.contentSize.height - self.frame.size.height)+50) {
            if (self.footerView.hidden == NO) {
                self.footerView.text = @"正在加载更多..";
                if ([self.tableViewDelegate respondsToSelector:@selector(tableViewStartLoading)]) {
                    [self.tableViewDelegate tableViewStartLoading];
                }
            }
        }
    }
}

@end
