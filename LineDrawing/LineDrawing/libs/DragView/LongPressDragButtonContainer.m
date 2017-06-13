//
//  LongPressDragButtonContainer.m
//  LineDrawing
//
//  Created by G on 16/7/2.
//  Copyright © 2016年 G. All rights reserved.
//

#import "LongPressDragButtonContainer.h"

#define Margin 10
#define ItemInterSpace 10

#define Duration 0.2

@interface LongPressDragButtonContainer () {
    BOOL contain;
    CGPoint startPoint;
    CGPoint originPoint;
}

@property(assign, nonatomic) BOOL equalWidth;
@property(assign, nonatomic) NSInteger rowNum;

@end

@implementation LongPressDragButtonContainer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items withFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _items = [items mutableCopy];
        [self reloadData];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items rowNum:(NSInteger)rowNum withFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _items = [items mutableCopy];
        if (rowNum > 0) {
            _rowNum = rowNum;
            _equalWidth = YES;
        }
        [self reloadData];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    // 采用添加子视图的方式绘制
//    [self reloadData];
    
}

- (void)reloadData {
    if (_items) {
        [self clearSubviews];
        [self reloadItems:_items];
    }
}

- (void)reloadItems:(NSArray *)items {
    
    // 添加子视图
    CGFloat maxWidth = self.bounds.size.width - 2 * Margin;
    NSInteger row = 0; // 记录换行数
    NSInteger rowFirstIndex = 0; // 记录换行时的位置
    CGFloat rowMaxHeight = 0; // 记录换行中最大的高度
    CGFloat originY = Margin; // 记录当前y坐标
    for (NSInteger i = 0; i < items.count; i++)
    {
        UIView *btn = (UIView *)items[i];
        
        CGFloat btnWidth = btn.bounds.size.width;
        CGFloat btnHeight = btn.bounds.size.height;
        if (_equalWidth) {
            btnWidth = (maxWidth - (_rowNum - 1) * ItemInterSpace) / _rowNum;
            btnHeight = btnWidth;
        }
        CGFloat itemWithSpaceWidth = (ItemInterSpace + btnWidth);
        ;
        itemWithSpaceWidth = MIN(maxWidth, itemWithSpaceWidth);
        CGFloat originX = Margin + (i - rowFirstIndex) * itemWithSpaceWidth;
        if (originX + btnWidth > Margin + maxWidth) {
            rowFirstIndex = i;
            row++;
            originY += (rowMaxHeight + ItemInterSpace);
            rowMaxHeight = btnHeight;
            originX = Margin;
        }
        
        rowMaxHeight = MAX(btnHeight, rowMaxHeight);
        
        btn.frame = CGRectMake(originX, originY, btnWidth, btnHeight);
        btn.tag = i;
        [self addSubview:btn];
        
        if (i == _items.count - 1) {
            CGRect selfFrame = self.frame;
            selfFrame.size.height = CGRectGetMaxY(btn.frame) + Margin;
            self.frame = selfFrame;
        }
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(buttonLongPressed:)];
        [btn addGestureRecognizer:longGesture];
        
    }
    
}

- (void)setItems:(NSArray *)items {
    _items = [items mutableCopy];
    
    [self reloadData];
}

- (void)clearSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)addItem:(UIView *)item {
    //
}

- (void)deleteItem:(UIView *)item {
    //
}

- (void)layoutItems {
    
    // 添加子视图
    CGFloat maxWidth = self.bounds.size.width - 2 * Margin;
    NSInteger row = 0; // 记录换行数
    NSInteger rowFirstIndex = 0; // 记录换行时的位置
    CGFloat rowMaxHeight = 0; // 记录换行中最大的高度
    CGFloat originY = Margin; // 记录当前y坐标
    for (NSInteger i = 0; i < _items.count; i++)
    {
        UIView *btn = (UIView *)_items[i];
        
        CGFloat btnWidth = btn.bounds.size.width;
        CGFloat btnHeight = btn.bounds.size.height;
        if (_equalWidth) {
            btnWidth = (maxWidth - (_rowNum - 1) * ItemInterSpace) / _rowNum;
            btnHeight = btnWidth;
        }
        CGFloat itemWithSpaceWidth = (ItemInterSpace + btnWidth);
        ;
        itemWithSpaceWidth = MIN(maxWidth, itemWithSpaceWidth);
        CGFloat originX = Margin + (i - rowFirstIndex) * itemWithSpaceWidth;
        if (originX + btnWidth > Margin + maxWidth) {
            rowFirstIndex = i;
            row++;
            originY += (rowMaxHeight + ItemInterSpace);
            rowMaxHeight = btnHeight;
            originX = Margin;
        }
        
        rowMaxHeight = MAX(btnHeight, rowMaxHeight);
        
        btn.transform = CGAffineTransformIdentity;
        btn.frame = CGRectMake(originX, originY, btnWidth, btnHeight);
        btn.tag = i;
        
        if (i == _items.count - 1) {
            CGRect selfFrame = self.frame;
            selfFrame.size.height = CGRectGetMaxY(btn.frame) + Margin;
            self.frame = selfFrame;
        }
        
    }
    
    
    
}

- (void)buttonLongPressed:(UILongPressGestureRecognizer *)sender
{
    
    UIButton *btn = (UIButton *)sender.view;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        startPoint = [sender locationInView:sender.view];
        originPoint = btn.center;
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformMakeScale(1.1, 1.1);
            btn.alpha = 0.7;
        }];
        
    }
    else if (sender.state == UIGestureRecognizerStateChanged)
    {
        
        CGPoint newPoint = [sender locationInView:sender.view];
        CGFloat deltaX = newPoint.x-startPoint.x;
        CGFloat deltaY = newPoint.y-startPoint.y;
        btn.center = CGPointMake(btn.center.x+deltaX,btn.center.y+deltaY);
        //NSLog(@"center = %@",NSStringFromCGPoint(btn.center));
        NSInteger index = [self indexOfPoint:btn.center withButton:btn];
        if (index<0)
        {
            contain = NO;
        }
        else
        {
            [UIView animateWithDuration:Duration animations:^{
                /* 直接互换
                CGPoint temp = CGPointZero;
                UIButton *button = _items[index];
                temp = button.center;
                button.center = originPoint;
                btn.center = temp;
                originPoint = btn.center;
                contain = YES;
                 */
                
                if ([self.delegate respondsToSelector:@selector(itemWillChangeIn:index:)]) {
                    [self.delegate itemWillChangeIn:btn index:index];
                }
                
                // 按顺序移动
                CGPoint temp = CGPointZero;
                UIButton *button = _items[index];
                temp = button.center;
                btn.center = temp;
                originPoint = temp;
                contain = YES;
                
                [_items removeObject:btn];
                [_items insertObject:btn atIndex:index];
                
                [self layoutItems];
                
                if ([self.delegate respondsToSelector:@selector(itemDidChangeIn:index:)]) {
                    [self.delegate itemDidChangeIn:btn index:index];
                }
                
            }];
        }
        
        
    }
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        [UIView animateWithDuration:Duration animations:^{
            
            btn.transform = CGAffineTransformIdentity;
            btn.alpha = 1.0;
            if (!contain)
            {
                btn.center = originPoint;
            }
        }];
    }
}


- (NSInteger)indexOfPoint:(CGPoint)point withButton:(UIButton *)btn
{
    for (NSInteger i = 0;i<_items.count;i++)
    {
        UIButton *button = _items[i];
        if (button != btn)
        {
            if (CGRectContainsPoint(button.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

@end
