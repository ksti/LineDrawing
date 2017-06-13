//
//  LongPressDragButtonContainer.h
//  LineDrawing
//
//  Created by G on 16/7/2.
//  Copyright © 2016年 G. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoveItemDelegate;

@interface LongPressDragButtonContainer : UIView

@property(strong, nonatomic) NSMutableArray *items;
@property(assign, nonatomic) id<MoveItemDelegate> delegate;

- (instancetype)initWithItems:(NSArray *)items withFrame:(CGRect)frame;
- (instancetype)initWithItems:(NSArray *)items rowNum:(NSInteger)rowNum withFrame:(CGRect)frame;

@end

@protocol MoveItemDelegate <NSObject>

@optional
- (void)itemWillChangeIn:(UIButton *)item index:(NSInteger)index;
- (void)itemDidChangeIn:(UIButton *)item index:(NSInteger)index;

@end
