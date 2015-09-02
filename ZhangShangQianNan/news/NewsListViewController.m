//
//  NewsListViewController.m
//  大师兄CMS
//
//  Created by songdewei on 15/8/13.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsListViewController.h"
#import "NewsCustomTableView.h"
#import "NewsDetailViewController.h"

@interface NewsListViewController ()

@end

@implementation NewsListViewController
@synthesize scrollBar;
@synthesize mainScrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:WHITEBGCOLOR];
    // Do any additional setup after loading the view.
    //导航栏初始化
    self.scrollBar = [[NewsScrollBar alloc] initWithFrame:CGRectMake(0, 15, SWIDTH, 26)];
    self.scrollBar.showsHorizontalScrollIndicator = NO;
    self.navigationItem.titleView = self.scrollBar;
    //主界面初始化
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SWIDTH, SHEIGHT)];
    self.mainScrollView.pagingEnabled = YES;
    self.mainScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    
    //设置栏目
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"newsColumns" ofType:@"plist"];
    NSArray *columns = [NSArray arrayWithContentsOfFile:plistPath];
    self.scrollBar.columns = columns;
    self.scrollBar.selectedIndex = 0;
    self.scrollBar.buttonDelegate = self;
    [self.scrollBar show];
    CGRect frame = self.view.frame;
    CGFloat barHeight = self.navigationController.navigationBar.frame.size.height + self.tabBarController.tabBar.frame.size.height + 18;
    for (int i=0; i<[columns count]; i++) {
        NewsCustomTableView *tableView = [[NewsCustomTableView alloc] initWithFrame:CGRectMake(SWIDTH*i, frame.origin.x, SWIDTH, frame.size.height-barHeight)];
        tableView.catid = [[columns[i] objectForKey:@"catid"] intValue];
        tableView.detailDelegate = self;
        tableView.operationQueue = operationQueue;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [tableView show];
        [self.mainScrollView addSubview:tableView];
    }
    [self.mainScrollView setContentSize:CGSizeMake([columns count]*SWIDTH, 0)];
}

#pragma mark - menu action
- (void)buttonClicked:(NSInteger)buttonIndex{
    for (int i = 0; i<[self.scrollBar.columnButtons count]; i++) {
        UIButton *button = self.scrollBar.columnButtons[i];
        if (i == buttonIndex) {
            [self.scrollBar setButton:button forState:UIControlStateSelected];
            [self.mainScrollView setContentOffset:CGPointMake(SWIDTH*i, self.mainScrollView.contentOffset.y) animated:YES];
        }else{
            [self.scrollBar setButton:button forState:UIControlStateNormal];
        }
    }
}


- (void)showNewsDetailWithID:(NSInteger)newsID{
    NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] init];
    detailViewController.newsID = newsID;
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - scrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.mainScrollView == scrollView) {
        NSInteger index = self.mainScrollView.contentOffset.x/SWIDTH;
        for (int i=0; i<[self.scrollBar.columnButtons count]; i++) {
            UIButton *button = self.scrollBar.columnButtons[i];
            if (index == i) {
                [self.scrollBar setButton:button forState:UIControlStateSelected];
                CGFloat scaleWith = button.frame.origin.x - self.scrollBar.contentOffset.x;
                if ((scaleWith - SWIDTH)>-60) {
                    [self.scrollBar setContentOffset:CGPointMake(self.scrollBar.contentOffset.x+60, self.scrollBar.contentOffset.y) animated:YES];
                }
                if (scaleWith<0) {
                    [self.scrollBar setContentOffset:CGPointMake(self.scrollBar.contentOffset.x+scaleWith, self.scrollBar.contentOffset.y) animated:YES];
                }
            }else{
                [self.scrollBar setButton:button forState:UIControlStateNormal];
            }
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
