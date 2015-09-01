//
//  ForumDisplayViewController.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumDisplayView.h"
#import "ForumThreadViewController.h"

@interface ForumDisplayViewController : UIViewController<UIScrollViewDelegate,ForumDisplayDelegate>

@property(nonatomic,retain)UISegmentedControl *segmentBar;
@property(nonatomic,retain)UIScrollView *mainScrollView;
@end
