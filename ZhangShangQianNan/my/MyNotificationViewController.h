//
//  MyNotificationViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/27.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXUserStatus.h"
#import "DSXTableView.h"
@interface MyNotificationViewController : UIViewController<DSXTableViewDelegate>{
    @private
    int _page;
}

@property(nonatomic,retain)NSOperationQueue *operationQueue;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@property(nonatomic,retain)DSXTableView *tableView;
@end
