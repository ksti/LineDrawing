//
//  AppDelegate.m
//  LineDrawing
//
//  Created by G on 16/6/20.
//  Copyright (c) 2016年 G. All rights reserved.
//

#import "AppDelegate.h"

#import "UMSocialQQHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialWechatHandler.h"

#import <UMCommunitySDK/UMCommunitySDK.h>
#import "UMCommunityUI.h"

#import "UMComMessageManager.h"
#import "UMComLoginManager.h"

#import "UINavigationController+StatusBar.h"
#import "MLTransition.h"

#import "NavigationViewController.h"

//设置友盟社区appKey、appSecret
#define UMengCommunityAppkey @"57714028e0f55a52260014b6" // online
#define UMengCommunityAppSecret @"ca33333c308dc233fce4752738bc249c"

// 设置微信AppId、appSecret，分享url
#define kSelfDefineWXAppId @"wx96110a1e3af63a39"
#define kSelfDefineWXAppSecret @"c60e3d3ff109a5d17013df272df99199"
#define kSelfDefineUrlUMSocail @"http://www.umeng.com/social"
//设置分享到QQ互联的appId和appKey
#define kSelfDefineQQAppId @"1104955437"
#define kSelfDefineQQAppKey @"jYFc33iiSqW0lwrZ"
//设置新浪微博AppKey、appSecret
#define kSelfDefineSinaSSOAppKey @"275392174"
#define kSelfDefineSinaSSOAppSecret @"d96fb6b323c60a42ed9f74bfab1b4f7a"
#define kSelfDefineUrlSinaSSORedirectURL @"http://sns.whalecloud.com/sina2/callback"

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
    [UMCommunitySDK setAppkey:UMengCommunityAppkey withAppSecret:UMengCommunityAppSecret];
    
    [self settingNavBar];
    //
    [self handleNotificationWithLaunchOptions:launchOptions];
    //
    [self setUMSocialHandler];
    
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

- (void)handleNotificationWithLaunchOptions:(nullable NSDictionary *)launchOptions {
    //后台收到消息推送之后处理消息
    NSDictionary *notificationDict = [launchOptions valueForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if ([notificationDict valueForKey:@"umwsq"]) {//判断是否石友盟微社区的消息推送
        [UMComMessageManager startWithOptions:launchOptions];
        if ([notificationDict valueForKey:@"aps"]) // 点击推送进入
        {
            [UMComMessageManager didReceiveRemoteNotification:notificationDict];
        }
    } else {
        [UMComMessageManager startWithOptions:nil];
    }
}

- (void)setUMSocialHandler {
    // 设置微信AppId、appSecret，分享url
    //[UMSocialWechatHandler setWXAppId:@"wx96110a1e3af63a39" appSecret:@"c60e3d3ff109a5d17013df272df99199" url:@"http://www.umeng.com/social"];
    [UMSocialWechatHandler setWXAppId:kSelfDefineWXAppId appSecret:kSelfDefineWXAppSecret url:kSelfDefineUrlUMSocail];
    //设置分享到QQ互联的appId和appKey
    //[UMSocialQQHandler setQQWithAppId:@"1104606393" appKey:@"X4BAsJAVKtkDQ1zQ" url:@"http://www.umeng.com/social"];
    [UMSocialQQHandler setQQWithAppId:kSelfDefineQQAppId appKey:kSelfDefineQQAppKey url:kSelfDefineUrlUMSocail];
    //设置新浪微博的appKey和appSecret
    //[UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"275392174" secret:@"d96fb6b323c60a42ed9f74bfab1b4f7a" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:kSelfDefineSinaSSOAppKey secret:kSelfDefineSinaSSOAppSecret RedirectURL:kSelfDefineUrlSinaSSORedirectURL];
}

#pragma mark UMComLoginManager
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [UMComLoginManager handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如新浪微博SDK等
    }
    return result;
}

@end
