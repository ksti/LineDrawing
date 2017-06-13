//
//  QLTextView.h
//  Demo_QLTextView
//
//  Created by Shrek on 15/3/30.
//  Copyright (c) 2015年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QLTextView : UITextView

/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字的颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@end
