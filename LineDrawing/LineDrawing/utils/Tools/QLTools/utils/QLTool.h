//
//  QLTool.h
//  WorkAssistant
//
//  Created by Shrek on 15/6/4.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

/** ScreenSize */
#define QLScreenSize [UIScreen mainScreen].bounds.size
#define QLScreenWidth QLScreenSize.width
#define QLScreenHeight QLScreenSize.height

/** QLDEBUG Print | M:method, L:line, C:content*/
#ifdef DEBUG
#define QLLog(FORMAT, ...) fprintf(stderr,"M:%s|L:%d|C->%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define QLLog(FORMAT, ...)
//#define QLLog(FORMAT, ...) fprintf(stderr,"M:%s|L:%d|C->%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif

#define QLNotificationCenter [NSNotificationCenter defaultCenter]
#define ConfigUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]

#define QLColorWithRGB(redValue, greenValue, blueValue) ([UIColor colorWithRed:((redValue)/255.0) green:((greenValue)/255.0) blue:((blueValue)/255.0) alpha:1])
#define QLColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define QLColorRandom QLColorWithRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))

#define IOS_VERSION_7_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))

@interface QLTool : NSObject

+ (void)makeStarRedWithUILabel:(UILabel *)label;
+ (void)makeStarsRedWithUILabels:(NSArray *)labels;

+ (BOOL)isPhoneNumber:(NSString *)string;

@end
