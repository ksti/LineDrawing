//
//  UITabBar+SetBadgeView.h
//  TheNewThreeBoard
//
//  Created by syy on 16/6/30.
//  Copyright © 2016年 forp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (SetBadgeView)
- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点
@end
