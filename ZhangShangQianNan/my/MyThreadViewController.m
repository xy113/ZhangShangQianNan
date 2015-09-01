//
//  MyThreadViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/24.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "MyThreadViewController.h"
#import "ForumThreadViewController.h"
#import "DSXUIButton.h"
#import "DSXUtil.h"
#import "Config.h"
#import "DSXControl.h"


@interface MyThreadViewController ()

@end

@implementation MyThreadViewController
@synthesize userStatus;
@synthesize mainTableView;
@synthesize operationQueue;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WHITEBGCOLOR;
    self.userStatus = [[DSXUserStatus alloc] init];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - self.tabBarController.tabBar.frame.size.height;
    self.mainTableView = [[DSXTableView alloc] initWithFrame:frame];
    self.mainTableView.tableViewDelegate = self;
    self.mainTableView.pageSize = 20;
    [self.view addSubview:self.mainTableView];

    self.operationQueue = [[NSOperationQueue alloc] init];
    [self tableViewStartRefreshing];
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=my&ac=mythread&uid=%ld&page=%d",(long)self.userStatus.uid,_page];
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:urlString];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    if ([data length] > 2) {
        if (self.mainTableView.isRefreshing) {
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"mythread"];
        }
    }else {
        data = [[NSUserDefaults standardUserDefaults] dataForKey:@"mythread"];
    }
    [self.mainTableView reloadTableViewWithData:data];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source
- (void)tableViewStartRefreshing{
    _page = 1;
    [self downloadData];
}

- (void)tableViewStartLoading{
    _page++;
    [self downloadData];
}

- (void)tableViewLoadNothing{
    [[DSXUtil sharedUtil] informationWindowInView:self.view Size:CGSizeMake(180, 90) Message:@"你还没有发布主题"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"threadCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"threadCell"];
    }else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    NSDictionary *thread = [self.mainTableView.rows objectAtIndex:indexPath.row];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cell.contentView.frame.size.width-20, 50)];
    titleView.text = [thread objectForKey:@"subject"];
    titleView.font = [UIFont systemFontOfSize:18.0f weight:600];
    titleView.numberOfLines = 2;
    titleView.textAlignment = NSTextAlignmentLeft;
    titleView.textColor = [UIColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.00];
    [titleView sizeToFit];
    [cell.contentView addSubview:titleView];
    
    UILabel *dateline = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 140, 20)];
    dateline.text = [thread objectForKey:@"dateline"];
    dateline.font = [UIFont systemFontOfSize:12.0f];
    dateline.textColor = [UIColor grayColor];
    [cell.contentView addSubview:dateline];
    
    UIImageView *viewNumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-viewnum.png"]];
    viewNumIcon.frame = CGRectMake(cell.contentView.frame.size.width-100, 62, 16, 16);
    [cell.contentView addSubview:viewNumIcon];
    
    UILabel *viewsLabel = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-80, 60, 40, 20)];
    viewsLabel.text = [thread objectForKey:@"views"];
    viewsLabel.font = [UIFont systemFontOfSize:12.0f];
    viewsLabel.textColor = [UIColor grayColor];
    viewsLabel.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:viewsLabel];
    
    UIImageView *commentNumIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-commentnum.png"]];
    commentNumIcon.frame = CGRectMake(cell.contentView.frame.size.width-50, 62, 16, 16);
    [cell.contentView addSubview:commentNumIcon];
    
    UILabel *commentNumView = [[UILabel alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-30, 60, 30, 20)];
    commentNumView.text = [thread objectForKey:@"replies"];
    commentNumView.font = [UIFont systemFontOfSize:12.0f];
    commentNumView.textColor = [UIColor grayColor];
    commentNumView.textAlignment = NSTextAlignmentLeft;
    [cell.contentView addSubview:commentNumView];
    cell.tag = [[thread objectForKey:@"tid"] intValue];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    ForumThreadViewController *threadViewController = [[ForumThreadViewController alloc] init];
    threadViewController.tid = cell.tag;
    threadViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:threadViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
