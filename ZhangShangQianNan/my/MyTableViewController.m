//
//  MyTableViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/15.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "MyTableViewController.h"
#import "MyItemView.h"
#import "SDWebImageManager.h"
#import "MyFeedBackViewController.h"
#import "MyLoginViewController.h"
#import "MyThreadViewController.h"
#import "MyNotificationViewController.h"
#import "MyFavorViewController.h"
#import "MyAboutViewController.h"
#import "DSXUtil.h"
#import "Config.h"

@implementation MyTableViewController
@synthesize tableView = _tableView;
@synthesize userStatus;

- (void)viewDidLoad{
    [super viewDidLoad];
    //注册消息通知
    self.userStatus = [[DSXUserStatus alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangedNotification object:nil];
    
    CGRect frame = self.view.frame;
    frame.origin.y = frame.origin.y - 20;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, 60)];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 190)];
    headView.backgroundColor = [UIColor colorWithRed:0.70 green:0.86 blue:0.87 alpha:1.00];
    
    UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 80, 80)];
    avatarView.contentMode = UIViewContentModeScaleToFill;
    avatarView.layer.cornerRadius = 40.0f;
    avatarView.layer.masksToBounds = YES;
    
    UILabel *userNameView = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 100, 20)];
    userNameView.textAlignment = NSTextAlignmentCenter;
    userNameView.font = [UIFont systemFontOfSize:14.0f weight:500];
    userNameView.textColor = [UIColor whiteColor];
    
    if (self.userStatus.isLogined) {
        [avatarView setImage:self.userStatus.avatar];
        userNameView.text = self.userStatus.username;
        
        UIView *userPicView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
        [userPicView addSubview:avatarView];
        [userPicView addSubview:userNameView];
        [userPicView setCenter:headView.center];
        [headView addSubview:userPicView];
    }else {
        [avatarView setImage:[UIImage imageNamed:@"icon-mywhite.png"]];
        userNameView.text = @"登录账号";
        
        UIButton *buttonShowLogin = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 120)];
        [buttonShowLogin addSubview:avatarView];
        [buttonShowLogin addSubview:userNameView];
        [buttonShowLogin setCenter:headView.center];
        [buttonShowLogin addTarget:self action:@selector(showLogin) forControlEvents:UIControlEventTouchDown];
        [headView addSubview:buttonShowLogin];
    }
    
    self.tableView.tableHeaderView = headView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section ==1){
        return 1;
    }else if (section ==2){
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 70;
    }else{
        return 45;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
    }else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    CGFloat width = cell.contentView.frame.size.width;
    if (indexPath.section == 0) {
        CGFloat itemWidth = width/3;
        MyItemView *threadView = [[MyItemView alloc] initWithFrame:CGRectMake(0, 10, itemWidth, 50)];
        [threadView setImage:@"icon-my-thread.png" title:@"主题"];
        [threadView setTag:101];
        [threadView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:threadView];
        UIView *separatorLine1 = [[UIView alloc] initWithFrame:CGRectMake(itemWidth-1, 0, 0.80, 70)];
        separatorLine1.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00];
        [cell.contentView addSubview:separatorLine1];
        
        MyItemView *messageView = [[MyItemView alloc] initWithFrame:CGRectMake(itemWidth, 10, itemWidth, 50)];
        [messageView setImage:@"icon-message.png" title:@"消息"];
        [messageView setTag:102];
        [messageView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:messageView];
        
        UIView *separatorLine2 = [[UIView alloc] initWithFrame:CGRectMake(itemWidth*2-1, 0, 1.00, 70)];
        separatorLine2.backgroundColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00];
        [cell.contentView addSubview:separatorLine2];
        
        MyItemView *favorView = [[MyItemView alloc] initWithFrame:CGRectMake(itemWidth*2, 10, itemWidth, 50)];
        [favorView setImage:@"icon-my-favorite.png" title:@"收藏"];
        [favorView setTag:103];
        [favorView addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [cell.contentView addSubview:favorView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if (indexPath.section == 1) {
        cell.textLabel.text = @"清除缓存";
        float cacheSize = roundf([[SDImageCache sharedImageCache] getSize]/1048576);
        UILabel *cacheSizeLabel = [[UILabel alloc] init];
        cacheSizeLabel.text = [NSString stringWithFormat:@"%.2f MB",cacheSize];
        cacheSizeLabel.font = [UIFont systemFontOfSize:14.0f];
        cacheSizeLabel.textColor = [UIColor grayColor];
        [cacheSizeLabel sizeToFit];
        cell.accessoryView = cacheSizeLabel;
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"评分";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"反馈";
        }
        
        if (indexPath.row == 2) {
            cell.textLabel.text = @"关于";
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    //退出登录
    if (indexPath.section == 3) {
        UILabel *loginLabel = [[UILabel alloc] initWithFrame:cell.contentView.frame];
        loginLabel.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:loginLabel];
        
        if (self.userStatus.isLogined) {
            loginLabel.text = @"退出登录";
            loginLabel.textColor = [UIColor redColor];
        }else {
            loginLabel.text = @"登录";
            loginLabel.textColor = [UIColor blackColor];
        }
    }
    cell.layoutMargins = UIEdgeInsetsMake(0, 0, 0, 0);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    //清除缓存
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            /*
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"newsColumns" ofType:@"plist"];
            NSArray *newsColumns = [NSArray arrayWithContentsOfFile:plistPath];
            for (NSDictionary *column in newsColumns) {
                NSString *key = [NSString stringWithFormat:@"news_%d",[[column objectForKey:@"catid"] intValue]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
            }
            plistPath = [[NSBundle mainBundle] pathForResource:@"forums" ofType:@"plist"];
            NSArray *forumArray = [NSArray arrayWithContentsOfFile:plistPath];
            for (NSDictionary *group in forumArray) {
                if (group) {
                    for (NSDictionary *forum in [group objectForKey:@"forums"]) {
                        NSString *key2 = [NSString stringWithFormat:@"forum_%d",[[forum objectForKey:@"fid"] intValue]];
                        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key2];
                    }
                }
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"forum_new"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"forum_maxviews"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"forum_maxreplies"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"piclist"];
             */
            [[SDImageCache sharedImageCache] clearDisk];
            [self.tableView reloadData];
            [[DSXUtil sharedUtil] successWindowInView:self.view Size:CGSizeMake(80, 75) Message:@"清除成功"];
        }
    }
    
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.apple.com/cn/"]];
        }
        if (indexPath.row == 1) {
            MyFeedBackViewController *feedBackViewController = [[MyFeedBackViewController alloc] init];
            [self.navigationController pushViewController:feedBackViewController animated:YES];
        }
        if (indexPath.row == 2) {
            MyAboutViewController *aboutViewController = [[MyAboutViewController alloc] init];
            [aboutViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:aboutViewController animated:YES];
        }
    }
    
    if (indexPath.section == 3) {
        if (self.userStatus.isLogined) {
            [self.userStatus logout];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangedNotification object:nil];
        }else {
            MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
            [self presentViewController:loginViewController animated:YES completion:^{
            
            }];
        }
    }
}

#pragma mark - actions
- (void)buttonClick:(id)sender{
    if (self.userStatus.isLogined) {
        MyItemView *currentButton = (MyItemView *)sender;
        if (currentButton.tag == 101) {
            MyThreadViewController *threadViewController = [[MyThreadViewController alloc] init];
            [threadViewController setTitle:@"我的主题"];
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:threadViewController animated:YES];
        }
        if (currentButton.tag == 102) {
            MyNotificationViewController *notificationController = [[MyNotificationViewController alloc] init];
            [notificationController setTitle:@"我的消息"];
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:notificationController animated:YES];
        }
        if (currentButton.tag == 103) {
            MyFavorViewController *favorViewController = [[MyFavorViewController alloc] init];
            [favorViewController setTitle:@"我的收藏"];
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:favorViewController animated:YES];
        }
    }else {
        [self showLogin];
    }
}

- (void)showLogin{
    MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:^{
        
    }];
}

- (void)userStatusChanged{
    [self viewDidLoad];
}
@end
