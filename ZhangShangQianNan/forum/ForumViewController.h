//
//  ForumViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/16.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumCollectionViewCell.h"
#import "ForumReusableView.h"
#import "ForumListViewController.h"
#import "DSXUserStatus.h"

@interface ForumViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>{
    @private
    UIView *_menuBar;
}

@property(nonatomic,retain)UICollectionView *forumCollectionView;
@property(nonatomic,retain)UITableView *forumTableView;
@property(nonatomic,strong)NSArray *forumList;
@property(nonatomic,retain)UILabel *headTitleLabel;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@property(nonatomic,retain)UITableViewController *tableViewController;
@property(nonatomic,retain)UIViewController *collectionViewController;
@property(nonatomic,retain)UIBarButtonItem *rightBarButtonItem;

@end
