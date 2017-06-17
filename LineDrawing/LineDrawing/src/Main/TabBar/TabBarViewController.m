//
//  TabBarViewController.m
//  LineDrawing
//
//  Created by G on 16/6/28.
//  Copyright © 2016年 G. All rights reserved.
//

#import "TabBarViewController.h"

#import "FirstViewController.h"
#import "UMCommunityUI.h"

@interface TabBarViewController () {
    NSArray *_menuArray;
}

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    
    self.delegate = self;
    
    [self loadDefaultValues];
    [self setupTabBarItems];
    
    self.title = @"儿童简笔画";
    [self setSelectedIndex:0];
}

-(void)loadDefaultValues {
    NSArray *menuImageAry=@[@"compassA",@"briefcaseA"];
    NSArray *menuSelImageAry=@[@"compassB",@"briefcaseB"];
    NSArray *menuTitleAry=@[@"首页",@"社区"];
    
    NSMutableArray *arrMulMenu =[NSMutableArray array];
    for (NSInteger i=0; i<menuTitleAry.count;i++ ) {
        NSMutableDictionary *parDic=[NSMutableDictionary dictionary];
        [parDic setObject:menuImageAry[i] forKey:@"defaultImg"];
        [parDic setObject:menuSelImageAry[i] forKey:@"selectedImg"];
        [parDic setObject:menuTitleAry[i] forKey:@"title"];
        [arrMulMenu addObject:parDic];
    }
    _menuArray = arrMulMenu;
}

-(UIViewController *)getTabBarVC:(Class)classVC controllerType:(NSString *)type withDictionary:(NSDictionary *)dicMenu{
    
    UIViewController *temp;
    if ([type isEqualToString:@"storyboard"]) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        temp = [mainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(classVC)];
    } else if ([type isEqualToString:@"nib"]) {
        temp = [[classVC alloc] initWithNibName:NSStringFromClass(classVC) bundle:nil];
    } else {
        temp = [classVC new];
    }
    [temp setEdgesForExtendedLayout:UIRectEdgeNone];
    temp.tabBarItem.title = dicMenu[@"title"];
    temp.title = dicMenu[@"title"];
    temp.tabBarItem.image =[UIImage imageNamed:dicMenu[@"defaultImg"]];
    [temp.tabBarItem setSelectedImage:[[UIImage imageNamed: dicMenu[@"selectedImg"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [temp.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KColorNavRed} forState:UIControlStateSelected];
    [temp.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KColorNavRed} forState:UIControlStateNormal];
    return temp;
    
}

-(UIViewController *)getTabBarViewController:(UIViewController *)viewController withDictionary:(NSDictionary *)dicMenu{
    
    UIViewController *temp = viewController;
    [temp setEdgesForExtendedLayout:UIRectEdgeNone];
    temp.tabBarItem.title = dicMenu[@"title"];
    temp.title = dicMenu[@"title"];
    temp.tabBarItem.image =[UIImage imageNamed:dicMenu[@"defaultImg"]];
    [temp.tabBarItem setSelectedImage:[[UIImage imageNamed: dicMenu[@"selectedImg"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [temp.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KColorNavRed} forState:UIControlStateSelected];
    [temp.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:KColorNavRed} forState:UIControlStateNormal];
    return temp;
    
}

- (void)setupTabBarItems {
    
    /*
    //
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FirstViewController *firstVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    firstVC.tabBarItem.title=@"首页";
    firstVC.tabBarItem.image=[UIImage imageNamed:@"compassB"];
    
//    UINavigationController *navFirstVC = [[UINavigationController alloc] initWithRootViewController:firstVC];
    
    //
    UIViewController *communityViewController2 = [UMCommunity getFeedsViewController];
    communityViewController2.tabBarItem.title=@"社区";
    communityViewController2.tabBarItem.image=[UIImage imageNamed:@"briefcaseB"];
    
    [self setViewControllers:@[firstVC, communityViewController2]];
    */
    
//    FirstViewController *firstVC =(FirstViewController *)[self getTabBarVC:[FirstViewController class] controllerType:@"storyboard" withDictionary:_menuArray[0]];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FirstViewController *firstVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"FirstViewController"];
    firstVC = (FirstViewController *)[self getTabBarViewController:firstVC withDictionary:_menuArray[0]];
    [self addChildViewController:firstVC];
    
    UIViewController *communityViewController2 = [UMCommunityUI navigationViewController];
    communityViewController2 = [self getTabBarViewController:communityViewController2 withDictionary:_menuArray[1]];
    [self addChildViewController:firstVC];
    
    [self setViewControllers:@[firstVC,communityViewController2]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (self.selectedIndex == 0) {
        self.title = @"儿童简笔画精选";
    } else {
        self.title = nil;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
