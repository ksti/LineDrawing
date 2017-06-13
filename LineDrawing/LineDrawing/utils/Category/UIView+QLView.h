//
//  UIView+QLView.h
//  HeartNet
//
//  Created by Shrek on 15/12/11.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QLView)

- (void)setCornerRadius:(CGFloat)cornerRadius;
- (void)setBorder:(CGFloat)border borderColor:(UIColor *)color;
- (void)setCornerRadius:(CGFloat)cornerRadius border:(CGFloat)border;
- (void)setCornerRadius:(CGFloat)cornerRadius border:(CGFloat)border borderColor:(UIColor *)color;

@end
