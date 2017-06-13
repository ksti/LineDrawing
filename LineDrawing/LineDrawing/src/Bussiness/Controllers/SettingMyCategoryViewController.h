//
//  SettingMyCategoryViewController.h
//  LineDrawing
//
//  Created by G on 16/7/2.
//  Copyright © 2016年 G. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^blockPop)();

@interface SettingMyCategoryViewController : UIViewController

@property(strong, nonatomic)NSMutableArray *myCategoryTitles;
@property(strong, nonatomic)NSMutableArray *otherCategoryTitles;

@property (copy, nonatomic) void(^blockPop)(NSMutableArray *myCategories, NSMutableArray *otherCategories);

@end
