//
//  SubPageViewController.m
//  LineDrawing
//
//  Created by G on 16/6/20.
//  Copyright (c) 2016年 G. All rights reserved.
//

#import "SubPageViewController.h"

#import "ContentCollectionView.h"
#import "CollectionImagesModel.h"

@interface SubPageViewController () {
    ContentCollectionView *_collectionView;
}

@end

@implementation SubPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setup];
    if (self.categoryId) {
        [self requestForCollectionImages:1 categoryId:self.categoryId keyWord:@"" userId:@""];
    }
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

- (void)viewDidLayoutSubviews {
    _collectionView.frame = self.view.bounds;
}

- (void)setup {
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        [self setEdgesForExtendedLayout:UIRectEdgeNone];
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    
    ContentCollectionView *collectionView = [ContentCollectionView contentCollectionView];
    collectionView.frame = self.view.frame;
    
    [self.view addSubview:collectionView];
    _collectionView = collectionView;
}

#pragma mark request

/**
 *  
 {"PageNum": 1,
 "CategoryID": "1",
 "KeyWord": "",
 "UserID": "1",
 "BookWord": "jbh"
 }

 */

- (void)requestForCollectionImages:(NSInteger)pageNum categoryId:(NSString *)categoryId keyWord:(NSString *)keyWord userId:(NSString *)userId {
    NSString *urlStr=[NSString stringWithFormat:@"%@%@",API_SERVER_URL, API_CHILDDRAW_CATEGORY];
    
    NSString *bookWord = @"jbh";
    NSMutableDictionary *dicParam = [NSMutableDictionary dictionary];
    NSMutableDictionary *dict=[NSMutableDictionary new];
    [dict setObject:bookWord forKey:@"BookWord"];
    [dict setObject:[NSNumber numberWithInteger:pageNum] forKey:@"PageNum"];
    [dict setObject:categoryId forKey:@"CategoryID"];
    [dict setObject:keyWord forKey:@"KeyWord"];
    [dict setObject:userId forKey:@"UserID"];
    
    NSString *p = [NSString jsonStringWithNSDictionary:dict];
    NSString *r = @"knowledge/requestKnowledge";
    [dicParam setObject:p forKey:@"Params"];
    [dicParam setObject:r forKey:@"r"];
    
    [SVProgressHUD show];
    [QLHttpTool postWithBaseUrl:urlStr parameters:dicParam withCookie:nil whenSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        DebugLog(@"data：%@",responseObject);
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dicResponse = (NSDictionary *)responseObject;
            
            if ([dicResponse[@"Result"] boolValue]) {
                
                [SVProgressHUD dismiss];
                
                NSArray *arrResponse = dicResponse[@"Datas"];
                NSMutableArray *arrMul =[NSMutableArray array];
                for (NSDictionary *dicRowData in arrResponse) {
                    CollectionImagesModel *model = [[CollectionImagesModel alloc] initWithDictionary:dicRowData];
                    [arrMul addObject:model];
                }
                _collectionView.models = arrMul;
                [_collectionView reloadData];
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
