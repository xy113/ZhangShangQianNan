//
//  ForumListViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumListViewController.h"
#import "ForumThreadViewController.h"
#import "ForumPostViewController.h"
#import "MyLoginViewController.h"
#import "DSXUserStatus.h"
#import "DSXCommon.h"

@interface ForumListViewController ()

@end

@implementation ForumListViewController
@synthesize fid;
@synthesize userStatus;
@synthesize mainTableView;
@synthesize operationQueue;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITEBGCOLOR;
    self.userStatus = [[DSXUserStatus alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSucceess) name:@"postSuccess" object:nil];
    //返回按钮
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    self.navigationItem.rightBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleAdd target:self action:@selector(postThread)];
    
    _keyName = [NSString stringWithFormat:@"forum_%ld",(long)self.fid];
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - (self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height + 18);
    self.mainTableView = [[DSXTableView alloc] initWithFrame:frame];
    self.mainTableView.pageSize = 20;
    self.mainTableView.tableViewDelegate = self;
    [self.view addSubview:self.mainTableView];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:_keyName]];
    [self.mainTableView.waitingView startAnimating];
    [self tableViewStartRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self.mainTableView.waitingView isAnimating]) {
        [self.mainTableView.waitingView stopAnimating];
    }
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=forumdisplay&filter=list&fid=%ld&page=%d",(long)self.fid,_page];
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:urlString];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if (self.mainTableView.isRefreshing && data.length > 2) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:_keyName];
    }
    [self.mainTableView reloadTableViewWithData:data];
}

#pragma mark - button actions
- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postThread{
    if (self.userStatus.isLogined) {
        ForumPostViewController *postViewController = [[ForumPostViewController alloc] init];
        postViewController.fid = self.fid;
        [self.navigationController pushViewController:postViewController animated:YES];
    }else {
        MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

- (void)userStatusChanged{
    self.userStatus = [DSXUserStatus new];
}

- (void)postSucceess{
    [self.mainTableView.waitingView startAnimating];
    [self tableViewStartRefreshing];
}


#pragma mark - Table view data source
- (void)tableViewStartRefreshing{
    _page = 1;
    [self.mainTableView setIsRefreshing:YES];
    [self downloadData];
}

- (void)tableViewRefreshedNothing{
    [[DSXUtil sharedUtil] informationWindowInView:self.view Size:CGSizeMake(180, 90) Message:@"该板块尚无主题"];
}

- (void)tableViewStartLoading{
    _page++;
    [self downloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *thread = [self.mainTableView.rows objectAtIndex:indexPath.row];
    ForumDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadCell"];
    if (cell == nil) {
        cell = [[ForumDisplayCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"threadCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    // Configure the cell...
    CGRect frame = cell.contentView.frame;
    frame.size.width = SWIDTH;
    cell.contentView.frame = frame;
    cell.tag = [[thread objectForKey:@"tid"] intValue];
    [cell setCellForDictionary:thread];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
