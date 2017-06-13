//
//  UIView+QLView.m
//  HeartNet
//
//  Created by Shrek on 15/12/11.
//  Copyright © 2015年 Shreker. All rights reserved.
//

#import "UIView+QLView.h"

@implementation UIView (QLView)

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
    [self.layer setMasksToBounds:YES];
}
- (void)setBorder:(CGFloat)border borderColor:(UIColor *)color {
    [self.layer setBorderColor:color.CGColor];
    [self.layer setBorderWidth:border];
    [self.layer setMasksToBounds:YES];
}
- (void)setCornerRadius:(CGFloat)cornerRadius border:(CGFloat)border borderColor:(UIColor *)color {
    if (color == nil) {
        color = [UIColor lightGrayColor];
    }
    [self setBorder:border borderColor:color];
    [self setCornerRadius:cornerRadius];
}
- (void)setCornerRadius:(CGFloat)cornerRadius border:(CGFloat)border {
    [self setCornerRadius:cornerRadius border:border borderColor:[UIColor lightGrayColor]];
}

@end
