//
//  HeadView.m
//  Test_ UICollectionView
//
//  Created by forp on 15/9/25.
//  Copyright (c) 2015年 forp. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (void)awakeFromNib {
    // Initialization code
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)drawRect:(CGRect)rect {
    //
}
//没进
- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}
//进了
+ (void)initialize
{
    if (self == [HeadView class]) {
        //
    }
}
//没进
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //
    }
    return self;
}
//进了//flowLayout.headerReferenceSize = CGSizeMake(320, 20);
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.textLabel];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}




@end
