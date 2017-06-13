//
//  ContentCollectionView.m
//  LineDrawing
//
//  Created by G on 16/6/20.
//  Copyright (c) 2016年 G. All rights reserved.
//

#import "ContentCollectionView.h"

#import "MJPhoto.h"
#import "MJPhotoView.h"
#import "MJPhotoBrowser.h"
#import "MJRefresh.h"

#import "CollectionImagesModel.h"
#import "ImagesCollectionViewCell.h"
#import "HeadView.h"
#import "FootView.h"

@interface ContentCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, MJPhotoBrowserDelegate> {
    NSMutableArray *_largeImageModels;
    NSMutableArray *_largeImageUrlAry;
}

@end

@implementation ContentCollectionView

static NSString *collectionViewCellIdentifier = @"collectionViewCell";
static NSString *headerIdentifier = @"header";
static NSString *footerIdentifier = @"footer";

- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

+ (ContentCollectionView *)contentCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.itemSize = CGSizeMake(100, 100);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    ContentCollectionView *collectionView = [[ContentCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = collectionView;
    collectionView.delegate = collectionView;
    
//    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:collectionViewCellIdentifier];
    [collectionView registerNib:[UINib nibWithNibName:@"ImagesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:collectionViewCellIdentifier];
    [collectionView registerClass:[HeadView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];//头部
    [collectionView registerNib:[UINib nibWithNibName:@"FootView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];//尾部
    
    return collectionView;
}

- (void)setModels:(NSArray<CollectionImagesModel *> *)models {
    _models = models;
    
    if (_largeImageModels) {
        [_largeImageModels removeAllObjects];
    } else {
        _largeImageModels = [NSMutableArray array];
    }
    for (CollectionImagesModel *model in models) {
        NSMutableArray *mArrModelContent = [model.arrContent mutableCopy];
        for (NSUInteger index = 0; index < mArrModelContent.count; index ++) {
            NSString *strImgUrl = [mArrModelContent objectAtIndex:index];
            [mArrModelContent replaceObjectAtIndex:index withObject:[NSString stringWithFormat:@"%@%@",API_IMAGES_URL, strImgUrl]];
        }
        [_largeImageModels addObject:mArrModelContent];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _models.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arrContentImages = _models[section].arrContent;
    return arrContentImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImagesCollectionViewCell *cell = (ImagesCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:collectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    CollectionImagesModel *model = [_models objectAtIndex:indexPath.section];
    NSArray *arrContentImages = model.arrContent;
    NSString *strImageUrl = arrContentImages[indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",API_IMAGES_URL, strImageUrl]];
    [cell.imageView sd_setImageWithURL:imageUrl placeholderImage:nil];
    cell.imageView.tag = indexPath.row;
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
    ImagesCollectionViewCell *cell = (ImagesCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [self viewLargeImageView:cell.imageView indexPath:indexPath];
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    /*
     if (kind == UICollectionElementKindSectionHeader) {
     HeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
     //        TestCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
     headerView.textLabel.text = @"我是头部!";
     headerView.textLabel.textAlignment = NSTextAlignmentCenter;
     headerView.textLabel.textColor = [UIColor whiteColor];
     return headerView;
     }
     FootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
     footerView.textLabel.text = @"我是尾部!";
     footerView.textLabel.textAlignment = NSTextAlignmentCenter;
     footerView.textLabel.textColor = [UIColor whiteColor];
     return footerView;
     */
    
    CollectionImagesModel *model = _models[indexPath.section];
    
    if (kind == UICollectionElementKindSectionHeader) {
        HeadView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        //        TestCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        headerView.textLabel.text = model.strTitle;
        headerView.textLabel.font = [UIFont systemFontOfSize:11];
        headerView.textLabel.textAlignment = NSTextAlignmentCenter;
        headerView.textLabel.textColor = [UIColor grayColor];
        return headerView;
    } else if (kind == UICollectionElementKindSectionFooter) {
        FootView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        footerView.textLabel.text = @"---";
        footerView.textLabel.font = [UIFont systemFontOfSize:11];
        footerView.textLabel.textAlignment = NSTextAlignmentCenter;
        footerView.textLabel.textColor = [UIColor whiteColor];
        return footerView;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 0);
}

// 显示图片
- (void)showImages:(UIImageView *)imgView {
    if (_largeImageUrlAry.count <= 0) {
        return ;
    }
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_largeImageUrlAry.count];
    for (int i = 0; i<_largeImageUrlAry.count; i++) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:_largeImageUrlAry[i]]; // 图片路径
        photo.srcImageView = imgView; // 来源于哪个UIImageView
        
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = imgView.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    browser.delegate = self;
    //    [browser showInVC:self.navigationController];
    [browser show];
}

//查看大图
-(void)viewLargeImageView:(UIImageView *)imgView indexPath:(NSIndexPath *)indexPath
{
    if (_largeImageModels.count > indexPath.section) {
        _largeImageUrlAry = _largeImageModels[indexPath.section];
    }
    imgView.tag = indexPath.row;
    [self showImages:imgView];
}

//查看大图
-(void)viewLargeImageView:(UIImageView *)imgView
{
    [self showImages:imgView];
}

//查看大图
-(void)viewLargeImage:(UITapGestureRecognizer *)tap
{
    UIImageView *im=(UIImageView*)tap.view;
    
    [self showImages:im];
}

#pragma mark MJPhotoBrowserDelegate
- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser photoViewDidEndZoom:(MJPhotoView *)photoView {
    NSLog(@"photoBrowser:photoViewDidEndZoom: --%zd",photoView.photo.srcImageView.tag);
}


#pragma mark request

@end
