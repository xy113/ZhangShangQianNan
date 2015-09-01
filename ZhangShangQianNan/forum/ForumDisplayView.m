//
//  ForumDisplayView.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumDisplayView.h"
#import "ForumDisplayCell.h"
#import "Config.h"
#import "DSXControl.h"
#import "DSXUtil.h"

@implementation ForumDisplayView
@synthesize filter;
@synthesize rows;
@synthesize operationQueue;
@synthesize viewThreadDelegate;
- (void)show{
    if (self.filter == nil) {
        self.filter = @"new";
    }
    _width = self.frame.size.width;
    _height = self.frame.size.height;
    _keyName = [NSString stringWithFormat:@"forum_%@",self.filter];
    self.rows = [NSMutableArray array];
    self.delegate = self;
    self.dataSource = self;
    self.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    _refreshControl = [[DSXControl sharedControl] refreshControlWithTarget:self action:@selector(refreshBegin)];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.refreshControl = _refreshControl;
    tableViewController.tableView = self;
    
    _footerView = [[DSXControl sharedControl] pullUpViewWithFrame:CGRectMake(0, 0, _width, 50)];
    _footerView.hidden = YES;
    self.self.tableFooterView = _footerView;
    
    CGPoint center = self.center;
    center.y = center.y - 50;
    _waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _waitingView.center = center;
    [self addSubview:_waitingView];
    
    if (self.operationQueue == nil) {
        self.operationQueue = [[NSOperationQueue alloc] init];
    }
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:_keyName]];
    [_waitingView startAnimating];
    [self refreshBegin];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if ([data length] > 2) {
        id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            if ([array count] < 20) {
                _footerView.hidden = YES;
            }else {
                _footerView.hidden = NO;
            }
            if (_isRefreshing) {
                [[NSUserDefaults standardUserDefaults] setObject:data forKey:_keyName];
                [self.rows removeAllObjects];
                [self reloadData];
            }
            for (NSDictionary *thread in array) {
                [self.rows addObject:thread];
            }
            [self reloadData];
        }
    }else {
        _footerView.hidden = YES;
    }
    if (_isRefreshing) {
        _isRefreshing = NO;
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
    if ([_waitingView isAnimating]) {
        [_waitingView stopAnimating];
    }
    _footerView.text = @"上拉加载更多";
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=forumdisplay&filter=%@&page=%d",self.filter,_page]];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}


- (void)refreshBegin{
    _page = 1;
    _isRefreshing = YES;
    [self downloadData];
}

- (void)loadMore{
    _page++;
    _footerView.text = @"正在加载更多..";
    [self downloadData];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.rows count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.rows objectAtIndex:indexPath.row];
    ForumDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadCell"];
    if (cell == nil) {
        cell = [[ForumDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"threadCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    cell.tag = [[dict objectForKey:@"tid"] intValue];
    [cell setCellForDictionary:dict];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    [self.viewThreadDelegate cellDidSelected:cell.tag];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self) {
        if (self.contentOffset.y>(self.contentSize.height - _height)+50) {
            if (!_footerView.hidden) {
                [self loadMore];
            }
        }
    }
}

@end
