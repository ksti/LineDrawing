//
//  ContentCollectionView.h
//  LineDrawing
//
//  Created by G on 16/6/20.
//  Copyright (c) 2016年 G. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionImagesModel;

@interface ContentCollectionView : UICollectionView

+ (ContentCollectionView *)contentCollectionView;

@property (nonatomic, strong) NSArray<CollectionImagesModel *> *models;

@end
