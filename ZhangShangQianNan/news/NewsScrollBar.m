//
//  NewsScrollBar.m
//  dsxcmsForIPhone
//
//  Created by songdewei on 15/8/19.
//  Copyright (c) 2015年 dsxcms. All rights reserved.
//

#import "NewsScrollBar.h"

@implementation NewsScrollBar
@synthesize columns;
@synthesize columnButtons;
@synthesize selectedIndex;
@synthesize buttonDelegate;
- (void)show{
    _buttonWidth = 60;
    _buttonHeight = 26;
    _buttonSize = CGSizeMake(_buttonWidth, _buttonHeight);
    self.columnButtons = [[NSMutableArray alloc] init];
    for (int i=0; i<[self.columns count]; i++) {
        NSDictionary *column = self.columns[i];
        //创建导航按钮
        CGRect buttonFrame = CGRectMake(i*_buttonWidth, 0, _buttonWidth, _buttonHeight);
        UIButton *menuButton = [[UIButton alloc] initWithFrame:buttonFrame];
        [menuButton setTitle:[column objectForKey:@"catname"] forState:UIControlStateNormal];
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [menuButton.layer setCornerRadius:5.0];
        [menuButton addTarget:self action:@selector(menuButtonClick:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:menuButton];
        [self.columnButtons addObject:menuButton];
    }
    [self setContentSize:CGSizeMake([self.columns count]*_buttonWidth, _buttonHeight)];
    [self setButton:self.columnButtons[self.selectedIndex] forState:UIControlStateSelected];
}

- (void)menuButtonClick:(id)sender{
    UIButton *currentButton = (UIButton *)sender;
    for (int i=0; i<[self.columnButtons count]; i++) {
        UIButton *button = self.columnButtons[i];
        if (button == currentButton) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [self setButton:button forState:UIControlStateSelected];
            [self.buttonDelegate buttonClicked:i];
        }else{
            [self setButton:button forState:UIControlStateNormal];
        }
    }
}


- (void)setButton:(UIButton *)button forState:(UIControlState)state{
    if (state == UIControlStateSelected) {
        [button setBackgroundColor:[UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1.00]];
        [button setTitleColor:[UIColor colorWithRed:0.09 green:0.44 blue:0.71 alpha:1.00] forState:UIControlStateNormal];
    }else{
        [button setBackgroundColor:[UIColor clearColor]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

@end
