//
//  MyThreadViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/24.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DSXUserStatus.h"
#import "DSXTableView.h"

@interface MyThreadViewController : UIViewController<DSXTableViewDelegate>{
    @private
    int _page;
}
@property(nonatomic,retain)DSXUserStatus *userStatus;
@property(nonatomic,retain)DSXTableView *mainTableView;
@property(nonatomic,retain)NSOperationQueue *operationQueue;
@end
