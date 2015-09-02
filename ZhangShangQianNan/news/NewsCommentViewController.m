//
//  NewsCommentViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/28.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsCommentViewController.h"
#import "UIImageView+WebCache.h"
#import "DSXCommon.h"

@interface NewsCommentViewController ()

@end

@implementation NewsCommentViewController
@synthesize aid;
@synthesize mainTableView;
@synthesize operationQueue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"全部评论"];
    [self.view setBackgroundColor:WHITEBGCOLOR];
    //[self.navigationController setToolbarHidden:NO];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    
    CGFloat tableHeight = SHEIGHT - (self.navigationController.navigationBar.frame.size.height + 18);
    self.mainTableView = [[DSXTableView alloc] initWithFrame:CGRectMake(0, self.view.frame.origin.y, SWIDTH, tableHeight)];
    self.mainTableView.pageSize = 20;
    self.mainTableView.tableViewDelegate = self;
    [self.view addSubview:self.mainTableView];
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.mainTableView.waitingView startAnimating];
    [self tableViewStartRefreshing];
    
    _sizeLable = [[UILabel alloc] initWithFrame:CGRectZero];
    _sizeLable.font = [UIFont systemFontOfSize:16.0];
    _sizeLable.numberOfLines = 0;
    _tipsView = [[UILabel alloc] init];
    _tipsView.hidden = YES;
    [self.mainTableView addSubview:_tipsView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _tipsView.hidden = YES;
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)downloadData{
    [self.operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=articlemisc&ac=fetchcomment&aid=%ld&page=%d",(long)self.aid,_page]];
        [self performSelectorOnMainThread:@selector(reloadTableViewWithData:) withObject:data waitUntilDone:YES];
    }];
}

- (void)reloadTableViewWithData:(NSData *)data{
    [self.mainTableView reloadTableViewWithData:data];
}

#pragma mark - UITableView delegate
- (void)tableViewStartRefreshing{
    _page = 1;
    [self.mainTableView setIsRefreshing:YES];
    [self downloadData];
}

- (void)tableViewRefreshedNothing{
    CGPoint center = self.view.center;
    _tipsView.text = @"文章暂无评论";
    [_tipsView sizeToFit];
    _tipsView.center = CGPointMake(center.x, 50);
    _tipsView.hidden = NO;
}

- (void)tableViewStartLoading{
    _page++;
    [self downloadData];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    [_sizeLable setFrame:CGRectMake(0, 0, SWIDTH-50, 0)];
    [_sizeLable setText:[self.mainTableView.rows[indexPath.row] objectForKey:@"message"]];
    [_sizeLable sizeToFit];
    return _sizeLable.frame.size.height + 60;
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
    CGRect frame = cell.contentView.frame;
    frame.size.width = SWIDTH;
    cell.contentView.frame = frame;
    NSDictionary *comment = [self.mainTableView.rows objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 30, 30)];
    [imageView sd_setImageWithURL:[comment objectForKey:@"userpic"]];
    imageView.layer.cornerRadius = 15.0;
    imageView.layer.masksToBounds = YES;
    [cell.contentView addSubview:imageView];
    
    UILabel *nameView = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, SWIDTH-40, 20)];
    nameView.text = [comment objectForKey:@"username"];
    nameView.font = [UIFont systemFontOfSize:14.0 weight:300];
    nameView.textColor = [UIColor grayColor];
    [nameView sizeToFit];
    [cell.contentView addSubview:nameView];
    
    UILabel *timeView = [[UILabel alloc] initWithFrame:CGRectMake(SWIDTH-110, 15, 100, 20)];
    timeView.text = [comment objectForKey:@"dateline"];
    timeView.font = [UIFont systemFontOfSize:14.0];
    timeView.textColor = [UIColor grayColor];
    timeView.textAlignment = NSTextAlignmentRight;
    [cell.contentView addSubview:timeView];
    
    UILabel *messageView = [[UILabel alloc] initWithFrame:CGRectMake(45, 40, SWIDTH-50, 0)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
