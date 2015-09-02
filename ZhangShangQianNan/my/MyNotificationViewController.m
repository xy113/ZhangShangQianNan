//
//  MyNotificationViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/27.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "MyNotificationViewController.h"
#import "MyShowNotificationViewController.h"
#import "Config.h"
#import "DSXUtil.h"
#import "DSXUIButton.h"
#import "DSXControl.h"

@interface MyNotificationViewController ()

@end

@implementation MyNotificationViewController
@synthesize operationQueue;
@synthesize userStatus;
@synthesize tableView = _tableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userStatus = [[DSXUserStatus alloc] init];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - (self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height + 18);
    self.tableView = [[DSXTableView alloc] initWithFrame:frame];
    self.tableView.tableViewDelegate = self;
    self.tableView.pageSize = 20;
    [self.view addSubview:self.tableView];
    
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self reloadTableViewWithData:[[NSUserDefaults standardUserDefaults] dataForKey:@"mymessage"]];
    [self.tableView.waitingView startAnimating];
    [self tableViewStartRefreshing];
}

- (void)clickBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=my&ac=mynotification&uid=%ld&page=%d",(long)self.userStatus.uid,_page];
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:urlString];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if (self.tableView.isRefreshing && data.length > 2) {
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"mymessage"];
    }
    [self.tableView reloadTableViewWithData:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (void)tableViewStartRefreshing{
    _page = 1;
    [self.tableView setIsRefreshing:YES];
    [self downloadData];
}

- (void)tableViewRefreshedNothing{
    [[DSXUtil sharedUtil] informationWindowInView:self.view Size:CGSizeMake(180, 80) Message:@"你没有收到任何消息"];
}

- (void)tableViewStartLoading{
    _page++;
    [self downloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"messageCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"messageCell"];
    }else{
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    // Configure the cell...
    CGRect frame = cell.contentView.frame;
    frame.size.width = SWIDTH;
    cell.contentView.frame = frame;
    NSDictionary *message = [self.tableView.rows objectAtIndex:indexPath.row];
//    cell.textLabel.text = [message objectForKey:@"note"];
//    cell.textLabel.font = [UIFont systemFontOfSize:16.0 weight:500];
//    cell.textLabel.numberOfLines = 2;
//    cell.textLabel.frame = CGRectMake(0, 0, cell.contentView.frame.size.width, 40);
//    [cell.textLabel sizeToFit];
//    
//    cell.detailTextLabel.text = [message objectForKey:@"dateline"];
//    cell.detailTextLabel.font = [UIFont systemFontOfSize:14.0 weight:0];
//    cell.detailTextLabel.textColor = [UIColor grayColor];
//    cell.detailTextLabel.layoutMargins = UIEdgeInsetsMake(10, 0, 0, 0);
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.tag = [[message objectForKey:@"id"] intValue];
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cell.contentView.frame.size.width-20, 30)];
    titleView.text = [message objectForKey:@"note"];
    titleView.font = [UIFont systemFontOfSize:16.0 weight:500];
    [cell.contentView addSubview:titleView];
    
    UILabel *timeView = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, cell.contentView.frame.size.width-20, 20)];
    timeView.text = [message objectForKey:@"dateline"];
    timeView.font = [UIFont systemFontOfSize:14.0 weight:0];
    timeView.textColor = [UIColor grayColor];
    [cell.contentView addSubview:timeView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    MyShowNotificationViewController *showController = [[MyShowNotificationViewController alloc] init];
    showController.messageid = cell.tag;
    [self.navigationController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:showController animated:YES];
}

@end
