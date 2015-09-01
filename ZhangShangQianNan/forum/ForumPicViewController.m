//
//  ForumPicViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/18.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumPicViewController.h"
#import "ForumThreadViewController.h"
#import "DSXControl.h"
#import "DSXUtil.h"

@interface ForumPicViewController ()

@end

@implementation ForumPicViewController

@synthesize piclist;
@synthesize mainTableView;
@synthesize operationQueue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"图片主题"];
    [self.view setBackgroundColor:GRAYBGCOLOR];
    [self.navigationController.tabBarItem setTitle:@"图片"];

    self.piclist = [NSMutableArray array];
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - 45;
    self.mainTableView = [[UITableView alloc] initWithFrame:frame];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.contentSize = self.view.frame.size;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 5, 0);
    
    [self.view addSubview:self.mainTableView];
    
    //下拉刷新控件
    _refreshControl = [[DSXControl sharedControl] refreshControlWithTarget:self action:@selector(tableViewStartRefreshing)];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.refreshControl = _refreshControl;
    tableViewController.tableView = self.mainTableView;
    
    //上拉加载视图
    _footerView = [[DSXControl sharedControl] pullUpViewWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _footerView.text = @"正在加载内容";
    self.mainTableView.tableFooterView = _footerView;
    
    //加载表数据
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"piclist"]];
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self tableViewStartRefreshing];
}

- (void)tableViewStartRefreshing{
    _page = 1;
    _isRefreshing = YES;
    [self.operationQueue addOperationWithBlock:^{
        NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=pic&page=%d",_page];
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:urlString];
        if (data) {[[NSUserDefaults standardUserDefaults] setObject:data forKey:@"piclist"];}
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}


- (void)reloadTableViewWithData:(NSData *)data{
    _footerView.text = @"上拉加载更多";
    if ([data length] > 2) {
        id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            if ([array count] < 20) {
                _showLoadMore = NO;
                _footerView.hidden = YES;
            }else {
                _showLoadMore = YES;
                _footerView.hidden = NO;
            }
            if (_isRefreshing) {
                [self.piclist removeAllObjects];
                [self.mainTableView reloadData];
            }
            for (NSDictionary *dict in array) {
                [self.piclist addObject:dict];
            }
            [self.mainTableView reloadData];
        }
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)loadMore{
    _page++;
    _footerView.text = @"正在加载更多..";
    [self.operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=pic&page=%d",_page]];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

#pragma mark - tableView datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.piclist count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 290.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForumPicViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"picCell"];
    if (cell == nil) {
        cell = [[ForumPicViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"picCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    NSDictionary *dict = [self.piclist objectAtIndex:indexPath.row];
    [cell setCellForDictionary:dict];
    [cell setTag:[[dict objectForKey:@"tid"] intValue]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    ForumThreadViewController *threadViewController = [[ForumThreadViewController alloc] init];
    threadViewController.tid = cell.tag;
    [threadViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:threadViewController animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.mainTableView) {
        if (((self.mainTableView.contentOffset.y + SHEIGHT) - self.mainTableView.contentSize.height)>50) {
            if (_showLoadMore) {
                [self loadMore];
            }
        }
    }
}

@end
