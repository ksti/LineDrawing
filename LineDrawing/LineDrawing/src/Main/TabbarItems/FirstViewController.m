//
//  ViewController.m
//  LineDrawing
//
//  Created by G on 16/6/20.
//  Copyright (c) 2016年 G. All rights reserved.
//

#import "FirstViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "UMCommunity.h"

#import "XTPageViewController.h"
#import "SubPageViewController.h"
#import "ContentCollectionView.h"

#import "SettingMyCategoryViewController.h"
#import "SearchViewController.h"
#import "CategoryModel.h"

#define LimitCategoryCount 10

//必须自身是导航器的delegate
@interface FirstViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, XTPageViewControllerDataSource, XTPageViewControllerDelegate> {
    
    XTPageViewController *_pageViewController;
    NSInteger _numberOfPages;
    NSMutableArray *_allCategoryModels;
    NSMutableDictionary *_allCategoryModelsDict;
    NSMutableArray *_myCategories;
    NSMutableArray *_otherCategories;
    NSMutableArray *_myCategoryModels;
    NSMutableArray *_otherCategoryModels;
}


@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadDefaultData];
    [self loadDefaultSetting];
    [self loadDefaultView];
    
    [self requestForCategories];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)loadDefaultData {
    _allCategoryModelsDict = [NSMutableDictionary dictionary];
    _myCategories = [NSMutableArray arrayWithObjects:@"标题1", @"标题2", @"标题3", @"标题4", @"标题5", @"标题6", @"标题7", @"标题8", @"标题9", @"标题10", nil];
    _otherCategories = [NSMutableArray arrayWithObjects:@"标题11", @"标题12", @"标题13", @"标题14", @"标题15", nil];
    _numberOfPages = _myCategories.count;
}

- (void)loadDefaultSetting {
//    self.title = @"儿童简笔画";
//    self.navigationItem.title = @"儿童简笔画";
//    self.navigationController.navigationItem.title = @"儿童简笔画";
    self.tabBarItem.title = @"首页";
}

- (void)loadDefaultView
{
    XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorSolid];
    pageViewController.tabBarBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    pageViewController.tabBarCursorColor = KColorNavRed;
    pageViewController.tabBarTitleColorNormal = [UIColor lightGrayColor];
    pageViewController.tabBarTitleColorSelected = [UIColor whiteColor];
    pageViewController.tabBarHeight = 35;
    /*
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add"]];
    imageView.frame = CGRectMake(0, 0, 20, 0);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    */
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor];
    [button setImage:[UIImage imageNamed:@"add"] forState:UIControlStateNormal];
    [button setContentMode:UIViewContentModeScaleAspectFit];
    button.frame = CGRectMake(0, 0, 35, 0);
    [button setEnlargeEdgeWithTop:10 right:10 bottom:10 left:10];
    [button addTarget:self action:@selector(toSettingMyCategory:) forControlEvents:UIControlEventTouchUpInside];
    pageViewController.tabBarRightItemView = button;
    
    pageViewController.dataSource = self;
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];
    
    _pageViewController = pageViewController;
}

-(void)loadNavigationItems{
    self.tabBarController.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"search"] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemAction)];
}

-(void)rightBarButtonItemAction{
    //#warning 搜索功能
    SearchViewController *vcNext = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:vcNext animated:YES];
}

- (void)toSettingMyCategory:(id)sender {
    SettingMyCategoryViewController *settingMyCategoryVC = [[SettingMyCategoryViewController alloc] init];
    settingMyCategoryVC.myCategoryTitles = _myCategories;
    settingMyCategoryVC.otherCategoryTitles = _otherCategories;
    settingMyCategoryVC.blockPop = ^(NSMutableArray *myCategories, NSMutableArray *otherCategories) {
        _myCategories = myCategories;
        _otherCategories = otherCategories;
        
        [self saveMyCategory];
        
        _numberOfPages = _myCategories.count;
        [_pageViewController reloadData];
    };
    [self.navigationController pushViewController:settingMyCategoryVC animated:YES];
}

#pragma mark utils
- (NSMutableArray *)categoriesWithModels:(NSArray *)models {
    NSMutableArray *mArrCategories = [NSMutableArray array];
    if (models.count > 0) {
        for (CategoryModel *model in models) {
            [mArrCategories addObject:model.strName];
        }
    }
    
    return mArrCategories;
    
}

- (void)reloadSubPages {
    _myCategories = [self categoriesWithModels:_myCategoryModels];
    _otherCategories = [self categoriesWithModels:_otherCategoryModels];
    _numberOfPages = _myCategories.count;
    [_pageViewController reloadData];
}

- (void)saveMyCategory {
    NSMutableArray *mArr = [NSMutableArray array];
    for (NSString *name in _myCategories) {
        if (_allCategoryModelsDict[name]) {
            [mArr addObject:_allCategoryModelsDict[name]];
        }
    }
    _myCategoryModels = [mArr mutableCopy];
    _otherCategoryModels = [NSMutableArray arrayWithArray:_allCategoryModels];
    [_otherCategoryModels removeObjectsInArray:_myCategoryModels];
    
    [[NSUserDefaults standardUserDefaults] setObject:_myCategories forKey:CONFIG_MYCATEGORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark XTPageViewControllerDelegate

- (NSInteger)numberOfPages {
    return _numberOfPages;
}

- (NSString*)titleOfPage:(NSInteger)page {
    return [NSString stringWithFormat:@"%@", [_myCategories objectAtIndex:page]];
}

- (UIViewController*)controllerOfPage:(NSInteger)page {
    SubPageViewController *controller = [[SubPageViewController alloc] init];
    CategoryModel *model = _myCategoryModels[page];
    controller.categoryId = model.strID;
    
    return controller;
}

- (CGFloat)widthOfTabBarItemForPage:(NSInteger)page {
    return [UIScreen mainScreen].bounds.size.width / 3;
}



#pragma mark request

- (void)requestForCategories {
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",API_SERVER_URL, API_CHILDDRAW_CATEGORY];
    
    NSString *bookWord = @"jbh";
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    NSString *p = [NSString stringWithFormat:@"{\"BookWord\":\"%@\"}",bookWord];
    NSString *r = @"category/requestCategory";
    [dicParam setObject:p forKey:@"Params"];
    [dicParam setObject:r forKey:@"r"];
    
    [SVProgressHUD show];
    [QLHttpTool postWithBaseUrl:urlStr parameters:dicParam withCookie:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"分类：%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicResponse = (NSDictionary *)responseObject;
            
            if ([dicResponse[@"Result"] boolValue]) {
                
                [SVProgressHUD dismiss];
                
                NSArray *arrResponse = dicResponse[@"Datas"];
                NSMutableArray *arrMul =[NSMutableArray array];
                for (NSDictionary *dicRowData in arrResponse) {
                    CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dicRowData];
                    [arrMul addObject:model];
                    [_allCategoryModelsDict setObject:model forKey:model.strName];
                }
                
                _allCategoryModels = arrMul;
                NSArray *myCategories = [[NSUserDefaults standardUserDefaults] objectForKey:CONFIG_MYCATEGORY];
                NSMutableArray *mArrMyCategoryModels = [NSMutableArray array];
                for (NSString *name in myCategories) {
                    if (_allCategoryModelsDict[name]) {
                        [mArrMyCategoryModels addObject:_allCategoryModelsDict[name]];
                    }
                }
                
                if (mArrMyCategoryModels.count > 0) {
                    _myCategoryModels = [NSMutableArray arrayWithArray:mArrMyCategoryModels];
                    NSMutableArray *otherCategoryModels = [NSMutableArray arrayWithArray:_allCategoryModels];
                    [otherCategoryModels removeObjectsInArray:mArrMyCategoryModels];
                    _otherCategoryModels = otherCategoryModels;
                    [self reloadSubPages];
                } else {
                    if (arrMul.count > LimitCategoryCount) {
                        _myCategoryModels = [NSMutableArray arrayWithArray:[arrMul subarrayWithRange:NSMakeRange(0, LimitCategoryCount)]];
                        _otherCategoryModels = [NSMutableArray arrayWithArray:[arrMul subarrayWithRange:NSMakeRange(LimitCategoryCount, _allCategoryModels.count-LimitCategoryCount)]];
                    } else {
                        _myCategoryModels = arrMul;
                        _otherCategoryModels = nil;
                    }
                    
                    [self reloadSubPages];
                }
                
            }else{
                [SVProgressHUD showAlterMessage:dicResponse[@"msg"]];
            }
            
        }else{
            [SVProgressHUD showErrorWithStatus:@"数据格式错误,请重试"];
        }
    } whenFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DebugLog(@"error===");
        [SVProgressHUD showAlterMessage:error.localizedDescription];
    }];
}


@end
