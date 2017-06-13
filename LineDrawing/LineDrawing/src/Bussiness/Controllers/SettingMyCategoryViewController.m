//
//  SettingMyCategoryViewController.m
//  LineDrawing
//
//  Created by G on 16/7/2.
//  Copyright © 2016年 G. All rights reserved.
//

#import "SettingMyCategoryViewController.h"

#import "LongPressDragButtonContainer.h"

@interface SettingMyCategoryViewController () {
    LongPressDragButtonContainer *_myCategoryContainer;
    LongPressDragButtonContainer *_otherCategoryContainer;
    
    NSMutableArray *_myCategories;
    NSMutableArray *_otherCategories;
    NSMutableArray *_myCategoryTitlesCopy;
    NSMutableArray *_otherCategoryTitlesCopy;
}

@end

@implementation SettingMyCategoryViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    _myCategories = _myCategoryContainer.items;
    _otherCategories = _otherCategoryContainer.items;
    
    [_myCategoryTitles removeAllObjects];
    for (UIButton *item in _myCategories) {
        [_myCategoryTitles addObject:item.titleLabel.text];
    }
    [_otherCategoryTitles removeAllObjects];
    for (UIButton *item in _otherCategories) {
        [_otherCategoryTitles addObject:item.titleLabel.text];
    }
    
    if (self.blockPop) {
        if (![_myCategoryTitlesCopy isEqualToArray:_myCategoryTitles]) {
            self.blockPop(_myCategoryTitles, _otherCategoryTitles);
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _myCategoryTitlesCopy = [_myCategoryTitles mutableCopy];
    _otherCategoryTitlesCopy = [_otherCategoryTitles mutableCopy];
    [self loadDefaultView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadDefaultView {
    
    [self setupMyCategoryView];
    [self setupOtherCategoryView];
    
}

- (UIButton *)itemWithTitle:(NSString *)title {
    CGFloat margin = 10;
    CGFloat btnInterSpace = 10;
    NSInteger rowNum = 3;
    CGFloat btnWidth = ([UIScreen mainScreen].bounds.size.width - 2 * margin - (rowNum - 1) * btnInterSpace) / rowNum; // 等宽平分屏幕
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor lightTextColor];
    btn.frame = CGRectMake(0, 0, btnWidth, 30);
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = 5;
    [btn setTitle:[NSString stringWithFormat:@"%@",title] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    
    return btn;
}

- (void)setupMyCategoryView {
    NSMutableArray *mArrItems = [NSMutableArray array];
    for (NSInteger i = 0;i<self.myCategoryTitles.count;i++)
    {
        UIButton *btn = [self itemWithTitle:self.myCategoryTitles[i]];
        btn.tag = i;
        
        // 事件
        [btn addTarget:self action:@selector(myCategoryChangeItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [mArrItems addObject:btn];
        
    }
    
    LongPressDragButtonContainer *container = [[LongPressDragButtonContainer alloc] initWithItems:[mArrItems copy] withFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _myCategoryContainer = container;
    _myCategories = mArrItems;
    
    [self.view addSubview:_myCategoryContainer];
}

- (void)setupOtherCategoryView {
    NSMutableArray *mArrItems = [NSMutableArray array];
    for (NSInteger i = 0;i<self.otherCategoryTitles.count;i++)
    {
        UIButton *btn = [self itemWithTitle:self.otherCategoryTitles[i]];
        btn.tag = i;
        
        // 事件
        [btn addTarget:self action:@selector(otherCategoryChangeItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [mArrItems addObject:btn];
        
    }
    
    LongPressDragButtonContainer *container = [[LongPressDragButtonContainer alloc] initWithItems:[mArrItems copy] withFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _otherCategoryContainer = container;
    
    // 更新frame
    [self updateCategoryFrame];
    
    [self.view addSubview:_otherCategoryContainer];
    _otherCategories = mArrItems;
}

- (void)updateCategoryFrame {
    CGRect otherCategoryFrame = _otherCategoryContainer.frame;
    otherCategoryFrame.origin.y = CGRectGetMaxY(_myCategoryContainer.frame) + 10;
    _otherCategoryContainer.frame = otherCategoryFrame;
}

- (void)myCategoryChangeItem:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *title = [_myCategoryTitles objectAtIndex:button.tag];
    // other 加
    [_otherCategoryTitles addObject:title];
    UIButton *item = [self itemWithTitle:title];
    item.tag = _otherCategories.count;
    // 事件
    [item addTarget:self action:@selector(otherCategoryChangeItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [_otherCategories addObject:item];
    
    // my 减
    [_myCategoryTitles removeObjectAtIndex:button.tag];
    [_myCategories removeObjectAtIndex:button.tag];
    
    // 刷新
    [self reloadCategory];
}

- (void)otherCategoryChangeItem:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSString *title = [_otherCategoryTitles objectAtIndex:button.tag];
    // my 加
    [_myCategoryTitles addObject:title];
    UIButton *item = [self itemWithTitle:title];
    item.tag = _myCategories.count;
    // 事件
    [item addTarget:self action:@selector(myCategoryChangeItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [_myCategories addObject:item];
    
    // other 减
    [_otherCategoryTitles removeObjectAtIndex:button.tag];
    [_otherCategories removeObjectAtIndex:button.tag];
    
    // 刷新
    [self reloadCategory];
}

- (void)reloadCategory {
    _myCategoryContainer.items = _myCategories;
    _otherCategoryContainer.items = _otherCategories;
    
    // 更新frame
    [self updateCategoryFrame];
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
