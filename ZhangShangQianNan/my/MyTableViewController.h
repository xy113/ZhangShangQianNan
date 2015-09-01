//
//  MyTableViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/15.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXUserStatus.h"

@interface MyTableViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>{
}


@property(nonatomic,retain)UITableView *tableView;
@property(nonatomic,retain)DSXUserStatus *userStatus;
@end
