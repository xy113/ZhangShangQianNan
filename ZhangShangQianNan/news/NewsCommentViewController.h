//
//  NewsCommentViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/28.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXTableView.h"

@interface NewsCommentViewController : UIViewController<DSXTableViewDelegate>{
    @private
    int _page;
    UILabel *_sizeLable;
    UILabel *_tipsView;
}

@property(nonatomic,assign)NSInteger aid;
@property(nonatomic,retain)DSXTableView *mainTableView;
@property(nonatomic,retain)NSOperationQueue *operationQueue;
@end
