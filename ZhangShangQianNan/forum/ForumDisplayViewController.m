//
//  ForumDisplayViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "Config.h"
#import "ForumDisplayViewController.h"

@interface ForumDisplayViewController ()

@end

@implementation ForumDisplayViewController

@synthesize segmentBar;
@synthesize mainScrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WHITEBGCOLOR;
    self.segmentBar = [[UISegmentedControl alloc] initWithItems:@[@"最新",@"热门",@"精华"]];
    self.segmentBar.selectedSegmentIndex = 0;
    self.segmentBar.frame = CGRectMake(0, 0, 180, 26);
    [self.segmentBar addTarget:self action:@selector(segmentBarChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentBar;
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.mainScrollView.contentSize = CGSizeMake(SWIDTH*3, 0);
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.delegate = self;
    [self.view addSubview:mainScrollView];
    
    CGFloat viewHeight = SHEIGHT - (self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height + 19);
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    ForumDisplayView *newTableView = [[ForumDisplayView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, viewHeight)];
    [self.mainScrollView addSubview:newTableView];
    newTableView.filter = @"new";
    newTableView.operationQueue = operationQueue;
    newTableView.viewThreadDelegate = self;
    [newTableView show];
    
    ForumDisplayView *hotTableView = [[ForumDisplayView alloc] initWithFrame:CGRectMake(SWIDTH, 0, SWIDTH, viewHeight)];
    [self.mainScrollView addSubview:hotTableView];
    hotTableView.filter = @"maxviews";
    hotTableView.operationQueue = operationQueue;
    hotTableView.viewThreadDelegate = self;
    [hotTableView show];
    
    ForumDisplayView *bestTableView = [[ForumDisplayView alloc] initWithFrame:CGRectMake(SWIDTH*2, 0, SWIDTH, viewHeight)];
    [self.mainScrollView addSubview:bestTableView];
    bestTableView.filter = @"maxreplies";
    bestTableView.operationQueue = operationQueue;
    bestTableView.viewThreadDelegate = self;
    [bestTableView show];
    
}

- (void)segmentBarChanged:(id)sender{
    UISegmentedControl *currentControl = (UISegmentedControl *)sender;
    NSInteger currentPage = currentControl.selectedSegmentIndex;
    [self.mainScrollView setContentOffset:CGPointMake(SWIDTH*currentPage, self.mainScrollView.contentOffset.y) animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == self.mainScrollView) {
        NSInteger selectedIndex = self.mainScrollView.contentOffset.x/SWIDTH;
        [self.segmentBar setSelectedSegmentIndex:selectedIndex];
    }
}

- (void)cellDidSelected:(NSInteger)tid{
    ForumThreadViewController *threadViewController = [[ForumThreadViewController alloc] init];
    threadViewController.tid = tid;
    [threadViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:threadViewController animated:YES];
}

@end
