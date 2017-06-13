//
//  AppDelegate.m
//  LineDrawing
//
//  Created by G on 16/6/20.
//  Copyright (c) 2016年 G. All rights reserved.
//

#import "AppDelegate.h"

#import "UMCommunity.h"

#import "UINavigationController+StatusBar.h"
#import "MLTransition.h"

#import "NavigationViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOption{
    // one line to validate
    [MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];//or MLTransitionGestureRecognizerTypeScreenEdgePan
    //...
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 友盟社区
    // 注：AppSecret要与AppKey匹配
//    setWithAppKey:@"54d19091fd98c55a19000406" withAppSecret:@"XXXXX"
    [UMCommunity setAppKey:@"57714028e0f55a52260014b6" withAppSecret:@"ca33333c308dc233fce4752738bc249c"]; //需要修改微社区的Appkey
    
    [self settingNavBar];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [viewController setEdgesForExtendedLayout:UIRectEdgeNone];
    }
}

// 设置导航栏样式
- (void)settingNavBar {
    //简单搞下demo颜色
    UIColor *navBarColor = [UIColor colorWithRed:0.95 green:0.2 blue:0.0 alpha:0.2];
    navBarColor = KColorNavRed;
    UIColor *navBarTintColor = [UIColor whiteColor];
    //导航栏
    [[UINavigationBar appearance]setBarTintColor:navBarColor];
    
    [[UINavigationBar appearance]setTintColor:navBarTintColor];
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18.0f];
    attributes[NSForegroundColorAttributeName] = navBarTintColor;
    NSShadow *shadow = [NSShadow new];
    shadow.shadowColor = [UIColor clearColor];
    attributes[NSShadowAttributeName] = shadow;
    [[UINavigationBar appearance] setTitleTextAttributes:attributes];
}

@end
