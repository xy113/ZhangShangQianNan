//
//  ForumViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/16.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumViewController.h"
#import "MyLoginViewController.h"
#import "MyTableViewController.h"
#import "MyThreadViewController.h"
#import "MyNotificationViewController.h"
#import "MyFavorViewController.h"
#import "DSXCommon.h"
#import "MyItemView.h"

@implementation ForumViewController

@synthesize forumCollectionView;
@synthesize forumTableView;
@synthesize forumList;
@synthesize headTitleLabel;
@synthesize userStatus;
@synthesize tableViewController;
@synthesize collectionViewController;

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"论坛板块"];
    [self.view setBackgroundColor:WHITEBGCOLOR];
    [self.navigationController.tabBarItem setTitle:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangedNotification object:nil];
    self.userStatus = [[DSXUserStatus alloc] init];
    if (self.userStatus.isLogined) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.layer.cornerRadius = 5.0;
        button.layer.masksToBounds = YES;
        [button setImage:self.userStatus.avatar forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchDown];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        _menuBar = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SWIDTH, 70)];
        CGFloat itemWidth = SWIDTH/3;
        MyItemView *threadItem = [[MyItemView alloc] initWithFrame:CGRectMake(0, 10, itemWidth, 40)];
        [threadItem setImage:@"icon-timefill.png" title:@"主题"];
        [threadItem setTag:101];
        [threadItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [_menuBar addSubview:threadItem];
        
        MyItemView *messageItem = [[MyItemView alloc] initWithFrame:CGRectMake(itemWidth, 10, itemWidth, 40)];
        [messageItem setImage:@"icon-messagefill.png" title:@"消息"];
        [messageItem setTag:102];
        [messageItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [_menuBar addSubview:messageItem];
        
        MyItemView *favorItem = [[MyItemView alloc] initWithFrame:CGRectMake(itemWidth*2, 10, itemWidth, 40)];
        [favorItem setImage:@"icon-favorfill.png" title:@"收藏"];
        [favorItem setTag:103];
        [favorItem addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchDown];
        [_menuBar addSubview:favorItem];
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, 70, SWIDTH, 0.5)];
        bottomLine.backgroundColor = [UIColor grayColor];
        [_menuBar addSubview:bottomLine];
        [_menuBar setBackgroundColor:WHITEBGCOLOR];
        //[_menuBar setHidden:YES];
        [self.navigationController.view insertSubview:_menuBar belowSubview:self.navigationController.navigationBar];
        
    }else{
        self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithImage:@"icon-my-avatar.png" target:self action:@selector(showLogin)];
    }
    self.rightBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithImage:@"icon-viewlist.png" target:self action:@selector(viewList)];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    //集合视图
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - (self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height + 18);
    self.forumCollectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
    self.forumCollectionView.backgroundColor = [UIColor whiteColor];
    self.forumCollectionView.delegate = self;
    self.forumCollectionView.dataSource = self;
    self.forumCollectionView.allowsMultipleSelection = YES;
    
    [self.forumCollectionView registerClass:[ForumCollectionViewCell class] forCellWithReuseIdentifier:@"forumCollectionCell"];
    [self.forumCollectionView registerClass:[ForumReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeadView"];
    
    //表视图
    self.forumTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.forumTableView.delegate = self;
    self.forumTableView.dataSource = self;
    
    //获取板块数据
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"forums" ofType:@"plist"];
    self.forumList = [NSArray arrayWithContentsOfFile:plistPath];

    //子控制器
    self.collectionViewController = [[UIViewController alloc] init];
    self.collectionViewController.view =self.forumCollectionView;
    [self addChildViewController:collectionViewController];
    [self.view addSubview:self.collectionViewController.view];
    
    self.tableViewController = [[UITableViewController alloc] init];
    self.tableViewController.tableView = self.forumTableView;
    [self addChildViewController:self.tableViewController];
}


- (void)viewWillDisappear:(BOOL)animated{
    _menuBar.frame = CGRectMake(0, -20, SWIDTH, 70);
}


#pragma mark - actions
- (void)showLogin{
    MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:^{
    
    }];
}

- (void)viewList{
    [self transitionFromViewController:collectionViewController toViewController:tableViewController duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        self.rightBarButtonItem.image = [[UIImage imageNamed:@"icon-viewgallery.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.rightBarButtonItem.action = @selector(viewGallery);
    }];
}

- (void)viewGallery{
    [self transitionFromViewController:self.tableViewController toViewController:self.collectionViewController duration:1 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        
    } completion:^(BOOL finished) {
        self.rightBarButtonItem.image = [[UIImage imageNamed:@"icon-viewlist.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.rightBarButtonItem.action = @selector(viewList);
    }];
}

- (void)showMenu{
    CGPoint center = _menuBar.center;
    if (_menuBar.frame.origin.y < 0) {
        center.y = center.y + 85;
    }else {
        center.y = center.y - 85;
    }
    [UIView animateWithDuration:0.4 animations:^{
        _menuBar.center = center;
    }];
}

- (void)userStatusChanged{
    [self viewDidLoad];
}

- (void)buttonClick:(id)sender{
    if (self.userStatus.isLogined) {
        MyItemView *currentButton = (MyItemView *)sender;
        UINavigationController *navigation;
        if (currentButton.tag == 101) {
            MyThreadViewController *threadViewController = [[MyThreadViewController alloc] init];
            [threadViewController setTitle:@"我的主题"];
            navigation = [[UINavigationController alloc] initWithRootViewController:threadViewController];
            [self presentViewController:navigation animated:YES completion:nil];
        }
        if (currentButton.tag == 102) {
            MyNotificationViewController *notificationController = [[MyNotificationViewController alloc] init];
            [notificationController setTitle:@"我的消息"];
            navigation = [[UINavigationController alloc] initWithRootViewController:notificationController];
            [self presentViewController:navigation animated:YES completion:nil];
        }
        if (currentButton.tag == 103) {
            MyFavorViewController *favorViewController = [[MyFavorViewController alloc] init];
            [favorViewController setTitle:@"我的收藏"];
            navigation = [[UINavigationController alloc] initWithRootViewController:favorViewController];
            [self presentViewController:navigation animated:YES completion:nil];
        }
        
    }else {
        [self showLogin];
    }
}

#pragma mark - CollectionView delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return [self.forumList count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = [self.forumList[section] objectForKey:@"forums"];
    return [array count];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((collectionView.frame.size.width-20)/3, 100);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 0, 5, 0);
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [[self.forumList[indexPath.section] objectForKey:@"forums"] objectAtIndex:indexPath.row];
    ForumCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"forumCollectionCell" forIndexPath:indexPath];
    if (cell) {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    cell.tag = [[dict objectForKey:@"forumid"] intValue];
    [cell setCellWithDictionary:dict];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    ForumListViewController *listViewController = [[ForumListViewController alloc] init];
    listViewController.fid = cell.tag;
    NSDictionary *dict = [[self.forumList[indexPath.section] objectForKey:@"forums"] objectAtIndex:indexPath.row];
    listViewController.title = [dict objectForKey:@"forumtitle"];
    [self.navigationController pushViewController:listViewController animated:YES];
}

// The view that is returned must be retrieved from a call to -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath:
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    ForumReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeadView" forIndexPath:indexPath];
        if (reusableview) {
            for (UIView *subview in reusableview.subviews) {
                [subview removeFromSuperview];
            }
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 30)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:18.0f weight:900];
        titleLabel.text = [self.forumList[indexPath.section] objectForKey:@"grouptitle"];
        
        [reusableview addSubview:titleLabel];
    }
    return reusableview;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size = {collectionView.frame.size.width,50};
    return size;
}

#pragma mark - TableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.forumList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.forumList[section] objectForKey:@"forums"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"forumTableCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"forumTableCell"];
    }else {
        for (UIView *subview in cell.contentView.subviews) {
            [subview removeFromSuperview];
        }
    }
    NSDictionary *forum = [[self.forumList[indexPath.section] objectForKey:@"forums"] objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 40, 40)];
    imageView.image = [UIImage imageNamed:[forum objectForKey:@"forumicon"]];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.layer.cornerRadius = 5.0;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 150, 40)];
    titleView.text = [forum objectForKey:@"forumtitle"];
    titleView.font = [UIFont systemFontOfSize:18.0 weight:500];
    [cell.contentView addSubview:titleView];
    
    cell.tag = [[forum objectForKey:@"forumid"] integerValue];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected:NO animated:YES];
    ForumListViewController *listViewController = [[ForumListViewController alloc] init];
    listViewController.fid = cell.tag;
    NSDictionary *forum = [[self.forumList[indexPath.section] objectForKey:@"forums"] objectAtIndex:indexPath.row];
    listViewController.title = [forum objectForKey:@"forumtitle"];
    [self.navigationController pushViewController:listViewController animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;{
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, SWIDTH, 50)];
    label.text = [self.forumList[section] objectForKey:@"grouptitle"];
    label.font = [UIFont systemFontOfSize:18.0f weight:900];
    [view addSubview:label];
    return view;
}

@end
