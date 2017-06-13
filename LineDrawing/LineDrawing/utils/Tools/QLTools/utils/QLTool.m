//
//  QLTool.m
//  WorkAssistant
//
//  Created by Shrek on 15/6/4.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import "QLTool.h"

@implementation QLTool

+ (void)makeStarRedWithUILabel:(UILabel *)label {
    NSString *strText = label.text;
    NSRange rangeStar = [strText rangeOfString:@"*"];
    NSMutableAttributedString *atrMAText = [[NSMutableAttributedString alloc] initWithString:strText];
    [atrMAText addAttribute:NSForegroundColorAttributeName value:QLColorWithRGB(231, 74, 74) range:rangeStar];
    [label setAttributedText:atrMAText];
}

+ (void)makeStarsRedWithUILabels:(NSArray *)labels {
    if (labels.count == 0) return;
    
    for (UILabel *label in labels) {
        NSAssert([label isKindOfClass:[UILabel class]], @"控件必须是一个UILabel");
        [self makeStarRedWithUILabel:label];
    }
}

+ (BOOL)isPhoneNumber:(NSString *)string {
    if ([string length] == 0) {
        return NO;
    }
    //^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    if (!isMatch) {
        return NO;
    }
    return YES;
}

@end
