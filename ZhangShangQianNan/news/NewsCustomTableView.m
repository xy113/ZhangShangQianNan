//
//  NewsCustomTableView.m
//  大师兄CMS
//
//  Created by songdewei on 15/8/13.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsCustomTableView.h"
#import "NewsCustomCell.h"
#import "UIImageView+WebCache.h"
#import "Config.h"
#import "NewsSlider.h"
#import "DSXUtil.h"

@implementation NewsCustomTableView

@synthesize rows;
@synthesize catid;
@synthesize detailDelegate;
@synthesize operationQueue;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _width  = self.frame.size.width;
        _height = self.frame.size.height;
        self.rows = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    }
    return self;
}

#pragma mark -
- (void)show{
    _keyName = [NSString stringWithFormat:@"news_%d",(int)self.catid];
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:_keyName]];
    
    //设置下拉刷新
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refreshControl addTarget:self action:@selector(refreshBegin) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self;
    tableViewController.refreshControl = _refreshControl;
    
    //设置上拉加载
    _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _width, 60)];
    _footerView.textAlignment = NSTextAlignmentCenter;
    _footerView.font = [UIFont systemFontOfSize:14.0f];
    _footerView.textColor = [UIColor grayColor];
    self.tableFooterView = _footerView;
    
    CGPoint center = self.center;
    center.y = center.y - 50;
    _waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _waitingView.center = center;
    [self addSubview:_waitingView];
    
    //刷新数据
    if (self.operationQueue == nil) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:_keyName]];
    [_waitingView startAnimating];
    [self refreshBegin];
}

- (void)refreshBegin{
    _page = 1;
    _isRefreshing = YES;
    [self .operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=articlelist&filter=all&catid=%d&page=%d",self.catid,_page]];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if ([data length] > 2) {
        if (_isRefreshing) {
            id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([dictionary isKindOfClass:[NSDictionary class]]) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:_keyName];
                id slideArray = [dictionary objectForKey:@"slides"];
                if ([slideArray isKindOfClass:[NSArray class]]) {
                    [self showSliderWithArray:slideArray];
                }
                id rowArray = [dictionary objectForKey:@"news"];
                if ([rowArray isKindOfClass:[NSArray class]]) {
                    [self reloadTableViewCellWithArray:rowArray];
                }
            }
        }else {
            id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if ([array isKindOfClass:[NSArray class]]) {
                [self reloadTableViewCellWithArray:array];
            }
        }
    }else{
        _footerView.hidden = YES;
    }
    _footerView.text = @"上拉加载更多";
    if (_isRefreshing) {
        _isRefreshing = NO;
    }
    
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    
    if ([_waitingView isAnimating]) {
        [_waitingView stopAnimating];
    }
}


- (void)showSliderWithArray:(NSArray *)array{
    [self.tableHeaderView removeFromSuperview];
    NewsSlider *slideView = [[NewsSlider alloc] initWithFrame:CGRectMake(0, 0, _width, 200) andData:array];
    [slideView setShowDelegate:self.detailDelegate];
    self.tableHeaderView = slideView;
}

- (void)reloadTableViewCellWithArray:(NSArray *)array{
    if ([array count] < 20) {
        _footerView.hidden = YES;
    }else {
        _footerView.hidden = NO;
    }
    if (_isRefreshing) {
        [self.rows removeAllObjects];
        [self reloadData];
    }
    for (NSDictionary *row in array) {
        [self.rows addObject:row];
    }
    [self reloadData];
}

- (void)loadMore{
    _page++;
    _footerView.text = @"正在加载更多..";
    [self.operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=articlelist&filter=news&catid=%d&page=%d",self.catid,_page]];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    [self.detailDelegate showNewsDetailWithID:cell.tag];
}


#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rows count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dictionary = [self.rows objectAtIndex:indexPath.row];
    NewsCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
    if (cell == nil) {
        cell = [[NewsCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newsCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    cell.tag = [[dictionary objectForKey:@"aid"] intValue];
    [cell setCellForDictionary:dictionary];
    return cell;
}


#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self) {
        if (self.contentOffset.y>(self.contentSize.height - _height)+50) {
            if (_footerView.hidden == NO) {
                [self loadMore];
            }
        }
    }
}
@end