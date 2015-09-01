//
//  NewsDetailViewController.m
//  大师兄CMS
//
//  Created by songdewei on 15/8/2.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsDetailViewController.h"
#import "MyLoginViewController.h"
#import "NewsCommentViewController.h"
#import "Config.h"


@interface NewsDetailViewController ()

@end

@implementation NewsDetailViewController
@synthesize newsID;
@synthesize article;
@synthesize detailWebView;
@synthesize maskView;
@synthesize postView;
@synthesize commentTextView;
@synthesize commentSendButton;
@synthesize userStatus;
@synthesize operationQueue;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:WHITEBGCOLOR];
    self.userStatus = [[DSXUserStatus alloc] init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged:) name:UserStatusChangedNotification object:nil];
    self.navigationItem.leftBarButtonItem = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleBack target:self action:@selector(clickBack)];
    UIBarButtonItem *likeBarButton = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleLike target:self action:@selector(addLike)];
    UIBarButtonItem *favorBarButton = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleFavor target:self action:@selector(addFavorite)];
    UIBarButtonItem *shareBarButton = [[DSXUIButton sharedButton] barButtonItemWithStyle:DSXBarButtonStyleShare target:self action:@selector(clickShare)];
    self.navigationItem.rightBarButtonItems = @[shareBarButton,favorBarButton,likeBarButton];

    //初始化webview
    self.article = nil;
    CGRect frame = self.view.frame;
    frame.size.height = frame.size.height;
    self.detailWebView = [[UIWebView alloc] initWithFrame:frame];
    self.detailWebView.delegate = self;
    self.detailWebView.hidden = YES;
    [self.view addSubview:self.detailWebView];
    
    _waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _waitingView.center = SCREENCENTER;
    [_waitingView startAnimating];
    [self.tabBarController.view addSubview:_waitingView];
    
    //初始化评论窗口
    _bottomButton = [[UIButton alloc] initWithFrame:CGRectMake(6, 6, SWIDTH-80, 32)];
    _bottomButton.layer.borderWidth = 0.6;
    _bottomButton.layer.borderColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.80 alpha:1.00].CGColor;
    _bottomButton.layer.cornerRadius = 3.0;
    _bottomButton.layer.masksToBounds = YES;
    _bottomButton.backgroundColor = [UIColor whiteColor];
    _bottomButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    _bottomButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _bottomButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [_bottomButton setTitle:@"我来说两句.." forState:UIControlStateNormal];
    [_bottomButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_bottomButton addTarget:self action:@selector(showPostView) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.toolbar addSubview:_bottomButton];
    
    _viewCommentButton = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH-70, 6, 60, 32)];
    [_viewCommentButton setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"barbg.png"]]];
    [_viewCommentButton addTarget:self action:@selector(viewComment) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.toolbar addSubview:_viewCommentButton];
    for (UIView *subview in _viewCommentButton.subviews) {
        [subview removeFromSuperview];
    }
    _commentNum = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 32)];
    _commentNum.font = [UIFont systemFontOfSize:12.0];
    _commentNum.textAlignment = NSTextAlignmentRight;
    _commentNum.textColor = [UIColor blackColor];
    [_viewCommentButton addSubview:_commentNum];
    
    UIImageView *commentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(44, 0, 16, 16)];
    [commentIcon setImage:[UIImage imageNamed:@"icon-comments.png"]];
    [commentIcon setContentMode:UIViewContentModeScaleToFill];
    [_viewCommentButton addSubview:commentIcon];
    
    self.maskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.alpha = 0.5;
    self.maskView.hidden = YES;
    UITapGestureRecognizer *maskViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidePostView)];
    [self.maskView addGestureRecognizer:maskViewTap];
    [self.tabBarController.view addSubview:self.maskView];
    
    
    self.postView = [[UIView alloc] init];
    self.postView.backgroundColor = BACKGROUNDCOLOR;
    self.postView.layer.borderWidth = 1.00;
    self.postView.layer.borderColor = [UIColor grayColor].CGColor;
    self.postView.hidden = YES;
    
    self.commentTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, SWIDTH-20, 100)];
    self.commentTextView.delegate = self;
    self.commentTextView.backgroundColor = [UIColor whiteColor];
    self.commentTextView.layer.borderWidth = 0.6;
    self.commentTextView.layer.borderColor = [UIColor grayColor].CGColor;
    self.commentTextView.font = [UIFont systemFontOfSize:16.0];
    self.commentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self.postView addSubview:self.commentTextView];
    
    self.commentSendButton = [[UIButton alloc] initWithFrame:CGRectMake(SWIDTH - 70, 115, 60, 30)];
    self.commentSendButton.backgroundColor = [UIColor grayColor];
    self.commentSendButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.commentSendButton.enabled = NO;
    [self.commentSendButton setTitle:@"发送" forState:UIControlStateNormal];
    [self.commentSendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.commentSendButton addTarget:self action:@selector(sendComment) forControlEvents:UIControlEventTouchDown];
    [self.postView addSubview:self.commentSendButton];
    [self.tabBarController.view addSubview:self.postView];
    
    //开始加载页面内容
    self.operationQueue = [[NSOperationQueue alloc] init];
    [self.operationQueue addOperationWithBlock:^{
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=articlemisc&ac=fetcharticle&aid=%ld",(long)self.newsID]];
        [self performSelectorOnMainThread:@selector(loadWebView:) withObject:data waitUntilDone:YES];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setToolbarHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setToolbarHidden:YES];
    if ([_waitingView isAnimating]) {
        [_waitingView stopAnimating];
    }
}

#pragma mark - UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView{

}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self.navigationController setToolbarHidden:NO];
    [_waitingView stopAnimating];
    [self.detailWebView setHidden:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    self.detailWebView.hidden = YES;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"加载失败,请检查网络";
    label.font = [UIFont systemFontOfSize:14.0];
    label.textColor = [UIColor grayColor];
    [label sizeToFit];
    [label setCenter:self.view.center];
    [self.view addSubview:label];
}

- (void)loadWebView:(NSData *)data{
    if ([data length] > 2) {
        id dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            self.article = dictionary;
            [_commentNum setText:[self.article objectForKey:@"commentnum"]];
            [self loadRequest];
        }
    }else {
        [[DSXUtil sharedUtil] wrongWindowInView:self.detailWebView Size:CGSizeMake(100, 80) Message:@"加载失败"];
    }
}

- (void)loadRequest{
    [self.operationQueue addOperationWithBlock:^{
        NSString *urlstring = [SITEAPI stringByAppendingFormat:@"&mod=articleview&aid=%ld",(long)self.newsID];
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlstring]];
        [self.detailWebView loadRequest:request];
        //[self performSelectorOnMainThread:@selector(showBottom) withObject:nil waitUntilDone:YES];
    }];
}

#pragma mark -
- (void)userStatusChanged:(NSNotification *)notification{
    self.userStatus = [DSXUserStatus sharedStatus];
    //[self viewDidLoad];
}

- (void)showPostView{
    if (self.userStatus.isLogined) {
        self.maskView.hidden = NO;
        self.postView.hidden = NO;
        self.postView.frame = CGRectMake(0, SHEIGHT-200, SWIDTH, SHEIGHT);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [self.commentTextView becomeFirstResponder];
    }else {
        MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
        [self presentViewController:loginViewController animated:YES completion:^{
            
        }];
    }
}

- (void)hidePostView{
    if ([self.commentTextView isFirstResponder]) {
        [self.commentTextView resignFirstResponder];
    }
    [self.postView setHidden:YES];
    [self.maskView setHidden:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)viewComment{
    NewsCommentViewController *commentViewController = [[NewsCommentViewController alloc] init];
    commentViewController.aid = self.newsID;
    [self.navigationController pushViewController:commentViewController animated:YES];
}

#pragma mark -
- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect frame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [self.postView setFrame:CGRectMake(0, frame.origin.y-198, SWIDTH, 200)];
}

#pragma mark - UITextView delegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView == self.commentTextView) {
        if (textView.text.length == 0) {
            self.commentSendButton.enabled = NO;
            self.commentSendButton.backgroundColor = [UIColor grayColor];
        }else{
            self.commentSendButton.enabled = YES;
            self.commentSendButton.backgroundColor = [UIColor redColor];
        }
    }
}

#pragma mark - button actions
-(void)showLogin{
    MyLoginViewController *loginViewController = [[MyLoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

- (void)clickBack{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addFavorite{
    if (self.userStatus.isLogined) {
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=articlemisc&ac=addfavorite&aid=%ld",(long)self.newsID]];
        if ([data length] > 0) {[[DSXUtil sharedUtil] successWindowInView:self.view Size:CGSizeMake(100, 80) Message:@"收藏成功"];}
    }else {
        [self showLogin];
    }
}

- (void)addLike{
    if (self.userStatus.isLogined) {
        NSData *data = [[DSXUtil sharedUtil] dataWithURL:[SITEAPI stringByAppendingFormat:@"&mod=articlemisc&ac=addlike&aid=%ld",(long)self.newsID]];
        if ([data length] > 0) {[[DSXUtil sharedUtil] successWindowInView:self.view Size:CGSizeMake(100, 80) Message:@"感兴趣"];}
    }else {
        [self showLogin];
    }
    
}

- (void)clickShare{
    NSString *title = [self.detailWebView stringByEvaluatingJavaScriptFromString:@"document.title"];
    NSString *content = [self.detailWebView stringByEvaluatingJavaScriptFromString:@"getSummary()"];
    NSString *image = [self.detailWebView stringByEvaluatingJavaScriptFromString:@"getImage()"];
    NSString *url = [self.detailWebView stringByEvaluatingJavaScriptFromString:@"getURL()"];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[title,content,image,url,content] forKeys:@[@"title",@"content",@"image",@"url",@"description"]];
    [[DSXUtil sharedUtil] shareWithView:self.view params:dict];
    
}

- (void)sendComment{
    if (self.commentTextView.text.length > 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@(self.userStatus.uid) forKey:@"uid"];
        [params setObject:@(self.newsID) forKey:@"id"];
        [params setObject:self.userStatus.username forKey:@"username"];
        [params setObject:self.commentTextView.text forKey:@"message"];
        NSData *data = [[DSXUtil sharedUtil] sendDataForURL:[SITEAPI stringByAppendingString:@"&mod=articlemisc&ac=postcomment"] params:params];
        if (data) {
            [self hidePostView];
            self.commentTextView.text = @"";
            [[DSXUtil sharedUtil] successWindowInView:self.tabBarController.view Size:CGSizeMake(120, 80) Message:@"发送成功"];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
