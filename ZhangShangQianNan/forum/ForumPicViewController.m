//
//  ForumPicViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/18.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumPicViewController.h"
#import "ForumThreadViewController.h"
#import "DSXCommon.h"
#import "SDWebImageManager.h"

@interface ForumPicViewController ()

@end

@implementation ForumPicViewController

@synthesize userStatus;
@synthesize mainTableView;
@synthesize operationQueue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"图片主题"];
    [self.view setBackgroundColor:GRAYBGCOLOR];
    [self.navigationController.tabBarItem setTitle:@"图片"];

    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - (self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height + 18);
    self.mainTableView = [[DSXTableView alloc] initWithFrame:frame];
    self.mainTableView.pageSize = 20;
    self.mainTableView.tableViewDelegate = self;
    self.mainTableView.backgroundColor = [UIColor clearColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.separatorInset = UIEdgeInsetsMake(0, 0, 5, 0);
    [self.view addSubview:self.mainTableView];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"piclist"]];
    [self.mainTableView.waitingView startAnimating];
    [self tableViewStartRefreshing];
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=pic&page=%d",_page]];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if (self.mainTableView.isRefreshing && [data length] > 2) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"piclist"];
    }
    [self.mainTableView reloadTableViewWithData:data];
}

#pragma mark - tableView delegate
- (void)tableViewStartRefreshing{
    _page = 1;
    [self.mainTableView setIsRefreshing:YES];
    [self downloadData];
}

- (void)tableViewRefreshedNothing{
    
}

- (void)tableViewStartLoading{
    _page++;
    [self downloadData];
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
    NSDictionary *dict = [self.mainTableView.rows objectAtIndex:indexPath.row];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [[SDImageCache sharedImageCache] clearMemory];
    // Dispose of any resources that can be recreated.
}

@end
