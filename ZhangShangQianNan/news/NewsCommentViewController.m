//
//  NewsCommentViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/28.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "DSXUIButton.h"
#import "DSXUtil.h"
#import "Config.h"
#import "UIImageView+WebCache.h"

@interface NewsCommentViewController ()

@end

@implementation NewsCommentViewController
@synthesize aid;
@synthesize commentList;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"全部评论"];
    [self.view setBackgroundColor:WHITEBGCOLOR];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"下拉刷新"];
    [_refreshControl addTarget:self action:@selector(refreshBegin) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = _refreshControl;
    
    _footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 50)];
    _footerView.textAlignment = NSTextAlignmentCenter;
    _footerView.font = [UIFont systemFontOfSize:14.0];
    _footerView.textColor = [UIColor grayColor];
    self.tableView.tableFooterView = _footerView;
    
    _label = [[UILabel alloc] init];
    _label.font = [UIFont systemFontOfSize:16.0];
    _label.numberOfLines = 0;
    
    self.commentList = [NSMutableArray array];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 0, 10, 10);
    self.operationQueue = [[NSOperationQueue alloc] init];
    _footerView.text = @"正在加载评论..";
    [self refreshBegin];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refreshBegin{
    _page = 1;
    _isRefreshing = YES;
    [self downloadData];
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=articlemisc&ac=fetchcomment&aid=%ld&page=%d",(long)self.aid,_page];
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:urlString];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if ([data length] > 2) {
        id array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([array isKindOfClass:[NSArray class]]) {
            if ([array count] < 20) {
                _footerView.text = @"";
                _isLoadMore = NO;
            }else {
                _footerView.text = @"上拉加载更多";
                _isLoadMore = YES;
            }
            if (_isRefreshing) {
                [self.commentList removeAllObjects];
                [self.tableView reloadData];
                _isRefreshing = NO;
            }
            for (NSDictionary *comment in array) {
                [self.commentList addObject:comment];
            }
            [self.tableView reloadData];
        }
    }else {
        _footerView.text = @"";
        _isLoadMore = NO;
    }
    if ([_refreshControl isRefreshing]) {
        [_refreshControl endRefreshing];
    }
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.commentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    _label.frame = CGRectMake(0, 0, SWIDTH-50, 0);
    _label.text = [self.commentList[indexPath.row] objectForKey:@"message"];
    [_label sizeToFit];
    return _label.frame.size.height + 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"commentCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"commentCell"];
    }else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }

    CGFloat width = cell.contentView.frame.size.width;
    NSDictionary *comment = [self.commentList objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    [imageView sd_setImageWithURL:[comment objectForKey:@"userpic"]];
    imageView.layer.cornerRadius = 15.0;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UILabel *nameView = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, width-40, 20)];
    nameView.text = [comment objectForKey:@"username"];
    nameView.font = [UIFont systemFontOfSize:14.0 weight:300];
    nameView.textColor = [UIColor grayColor];
    [nameView sizeToFit];
    [cell.contentView addSubview:nameView];
    
    UILabel *timeView = [[UILabel alloc] initWithFrame:CGRectMake(width-110, 15, 100, 20)];
    timeView.text = [comment objectForKey:@"dateline"];
    timeView.font = [UIFont systemFontOfSize:14.0];
    timeView.textColor = [UIColor grayColor];
    timeView.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:timeView];
    
    UILabel *messageView = [[UILabel alloc] initWithFrame:CGRectMake(45, 40, width-50, 0)];
    messageView.text = [comment objectForKey:@"message"];
    messageView.font = [UIFont systemFontOfSize:16.0];
    messageView.backgroundColor = [UIColor clearColor];
    messageView.numberOfLines = 0;
    [messageView sizeToFit];
    [cell.contentView addSubview:messageView];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == self.tableView) {
        if (self.tableView.contentOffset.y>(self.tableView.contentSize.height - SHEIGHT)+50) {
            if (_isLoadMore) {
                [self loadMore];
            }
        }
    }
}

- (void)loadMore{
    _page++;
    _footerView.text = @"正在加载更多..";
    [self downloadData];
}

@end
