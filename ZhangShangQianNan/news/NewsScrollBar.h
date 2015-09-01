//
//  NewsScrollBar.h
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MenuButtonDelegate<NSObject>
@required
- (void)buttonClicked:(NSInteger)buttonIndex;

@end

@interface NewsScrollBar : UIScrollView<UIScrollViewDelegate>{
    @private
    CGSize _buttonSize;
    CGFloat _buttonWidth;
    CGFloat _buttonHeight;
    
}

@property(nonatomic,strong)NSArray *columns;
@property(nonatomic,strong)NSMutableArray *columnButtons;
@property(nonatomic,assign)NSInteger selectedIndex;
@property(nonatomic,assign)id<MenuButtonDelegate> buttonDelegate;
- (void)show;
- (void)setButton:(UIButton *)button forState:(UIControlState)state;
@end
