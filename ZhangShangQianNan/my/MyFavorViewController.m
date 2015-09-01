//
//  MyFavorViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/24.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "MyFavorViewController.h"
#import "ForumThreadViewController.h"
#import "ForumDisplayViewController.h"
#import "NewsDetailViewController.h"
#import "DSXUIButton.h"
#import "Config.h"
#import "DSXUtil.h"
#import "DSXTableView.h"
#import "DSXControl.h"

@interface MyFavorViewController ()

@end

@implementation MyFavorViewController
@synthesize threadList;
@synthesize userStatus;
@synthesize operationQueue;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userStatus = [[DSXUserStatus alloc] init];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    self.navigationItem.rightBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleAdd target:self action:@selector(showThread)];
    
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - (self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height + 18);
    self.tableView = [[DSXTableView alloc] initWithFrame:frame];
    self.tableView.tableViewDelegate = self;
    self.tableView.pageSize = 20;
    [self.view addSubview:self.tableView];
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"myfavor"]];
    [self.tableView.waitingView startAnimating];
    [self tableViewStartRefreshing];
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=my&ac=myfavor&uid=%ld",(long)self.userStatus.uid]];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if (self.tableView.isRefreshing && data.length > 2) {
       [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"myfavor"];
    }
    [self.tableView reloadTableViewWithData:data];
}

- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showThread{
    ForumDisplayViewController *forumViewController = [[ForumDisplayViewController alloc] init];
    forumViewController.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    [self.navigationController pushViewController:forumViewController animated:YES];
}

#pragma mark - DSXTableView delegate
- (void)tableViewStartRefreshing{
    _page = 1;
    [self.tableView setIsRefreshing:YES];
    [self downloadData];
}

- (void)tableViewRefreshedNothing{
    [[DSXUtil sharedUtil] informationWindowInView:self.view Size:CGSizeMake(160, 80) Message:@"你还没有收藏过信息"];
}

- (void)tableViewStartLoading{
    _page++;
    [self downloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"favorCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    // Configure the cell...
    NSDictionary *thread = [self.tableView.rows objectAtIndex:indexPath.row];
    cell.textLabel.text = [thread objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:18.0f weight:500];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tag = [[thread objectForKey:@"favid"] intValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    NSDictionary *favor = [self.tableView.rows objectAtIndex:indexPath.row];
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    if ([[favor objectForKey:@"idtype"] isEqualToString:@"tid"]) {
        ForumThreadViewController *threadViewController = [[ForumThreadViewController alloc] init];
        threadViewController.tid = [[favor objectForKey:@"id"] intValue];
        threadViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:threadViewController animated:YES];
    }else {
        NewsDetailViewController *newsViewController = [[NewsDetailViewController alloc] init];
        newsViewController.newsID = [[favor objectForKey:@"id"] intValue];
        newsViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:newsViewController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
