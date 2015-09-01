//
//  ForumPicViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/18.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumPicViewCell.h"
#import "DSXTableView.h"

@class DSXUserStatus;
@interface ForumPicViewController : UIViewController<DSXTableViewDelegate>{
    @private
    int _page;
}
@property(nonatomic,retain)DSXUserStatus *userStatus;
@property(nonatomic,retain)DSXTableView *mainTableView;
@property(nonatomic,retain)NSOperationQueue *operationQueue;

@end
