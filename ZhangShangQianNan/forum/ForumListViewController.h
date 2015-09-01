//
//  ForumListViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Config.h"
#import "ForumDisplayCell.h"
#import "DSXTableView.h"

@class DSXUserStatus;
@interface ForumListViewController : UIViewController<DSXTableViewDelegate>{
    @private
    int _page;
    NSString *_keyName;
}

@property(nonatomic,assign)NSInteger fid;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@property(nonatomic,retain)DSXTableView *mainTableView;
@property(nonatomic,retain)NSOperationQueue *operationQueue;

@end
