//
//  ForumThreadViewController.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "ForumThreadViewController.h"
#import "ForumReplyViewController.h"
#import "MyLoginViewController.h"
#import "Config.h"
#import "DSXUserStatus.h"

@interface ForumThreadViewController ()

@end

@implementation ForumThreadViewController

@synthesize tid;
@synthesize threadWebView;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WHITEBGCOLOR;
    self.userStatus = [[DSXUserStatus alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangedNotification object:nil];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    UIBarButtonItem *shareBarButton = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleShare target:self action:@selector(clickShare)];
    UIBarButtonItem *favorBarButton = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleFavor target:self action:@selector(addFavorite)];
    UIBarButtonItem *replyBarButton = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleReply target:self action:@selector(addReply)];
    self.navigationItem.rightBarButtonItems = @[shareBarButton,favorBarButton,replyBarButton];
    
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height - 44;
    self.threadWebView = [[UIWebView alloc] initWithFrame:frame];
    self.threadWebView.delegate = self;
    [self.view addSubview:self.threadWebView];
    _waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _waitingView.center = SCREENCENTER;
    [self.tabBarController.view addSubview:_waitingView];
    [_waitingView startAnimating];
    
    self.thread = nil;
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperationWithBlock:^{
        NSString *urlString = [SITEAPI stringByAppendingFormat:@"&mod=forummisc&ac=fetchthread&tid=%ld",(long)self.tid];
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        [self performSelectorOnMainThread:@selector(loadWebView:) withObject:data waitUntilDone:YES];
    }];
}

- (void)loadWebView:(NSData *)data{
    if ([data length] > 2) {
        id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.thread = dictionary;
        }
    }
    if (self.thread != nil) {
        _page = 1;
        [self loadRequest];
        
        NSInteger replies = [[self.thread objectForKey:@"replies"] intValue];
        _totalPage = replies < 20 ? 1 : ceil(replies/20);
        
        _prevButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-toleft.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goPrevPage)];
        _pageButtonItem = [[UIBarButtonItem alloc] initWithTitle:[NSString stringWithFormat:@"%d/%d",_page,_totalPage] style:UIBarButtonItemStylePlain target:self action:nil];
        _nextButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon-toright.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goNextPage)];
        _fixButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        [self setupBottom];
    }else {
        [_waitingView stopAnimating];
        [[DSXUtil sharedUtil] wrongWindowInView:self.view Size:CGSizeMake(180, 80) Message:@"帖子已被删除"];
        [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(clickBack) userInfo:nil repeats:NO];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    if (_totalPage > 1) {
        self.navigationController.toolbarHidden = NO;
    }else {
        self.navigationController.toolbarHidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
    if ([_waitingView isAnimating]) {
        [_waitingView stopAnimating];
    }
}

#pragma mark - UIWebview delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [_waitingView stopAnimating];
}

- (void)setupBottom{
    if (_page <= 1) {
        self.toolbarItems = @[_fixButtonItem,_pageButtonItem,_fixButtonItem,_nextButtonItem];
    }else if (_page >= _totalPage){
        self.toolbarItems = @[_prevButtonItem,_fixButtonItem,_pageButtonItem,_fixButtonItem];
    }else {
        self.toolbarItems = @[_prevButtonItem,_fixButtonItem,_pageButtonItem,_fixButtonItem,_nextButtonItem];
    }
}

- (void)loadRequest{
    [self.operationQueue addOperationWithBlock:^{
        NSString *threadURL = [SITEAPI stringByAppendingFormat:@"&mod=viewthread&tid=%ld&page=%d",(long)self.tid,_page];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:threadURL]];
        [self.threadWebView loadRequest:request];
    }];
}

- (void)goPrevPage{
    if (_page <= 1) {
        return;
    }else {
        _page--;
        [self loadRequest];
    }
}

- (void)goNextPage{
    if (_page >= _totalPage) {
        return;
    }else {
        _page++;
        [self loadRequest];
    }
}

- (void)userStatusChanged{
    self.userStatus = [DSXUserStatus new];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickShare{
    NSString *title = [self.threadWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *content = [self.threadWebView stringByEvaluatingJavaScriptFromString:@"getSummary()"];
    NSString *image = [self.threadWebView stringByEvaluatingJavaScriptFromString:@"getImage()"];
    NSString *url = [self.threadWebView stringByEvaluatingJavaScriptFromString:@"getURL()"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[title,content,image,url,content] forKeys:@[@"title",@"content",@"image",@"url",@"description"]];
    [[DSXUtil sharedUtil] shareWithView:self.view params:dict];
}

- (void)addFavorite{
    if (self.userStatus.isLogined) {
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=forummisc&ac=addfavorite&tid=%ld",(long)self.tid]];
        if (data) {
            [[DSXUtil sharedUtil] successWindowInView:self.view Size:CGSizeMake(100, 80) Message:@"收藏成功"];
        }
    }else {
        MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
    
}

- (void)addReply{
    if (self.userStatus.isLogined) {
        ForumReplyViewController *replyViewController = [[ForumReplyViewController alloc] init];
        replyViewController.tid = self.tid;
        replyViewController.fid = [[self.thread objectForKey:@"fid"] intValue];
        replyViewController.title = @"回复";
        [self.navigationController pushViewController:replyViewController animated:YES];
    }else {
        MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
