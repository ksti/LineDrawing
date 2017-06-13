//
//  UIImage+QLImage.h
//  MirePo
//
//  Created by ZhuoJing01 on 14/11/6.
//  Copyright (c) 2014年 ZhuoJing01. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QLImageTypeJpg,
    QLImageTypePng,
    QLImageTypeBmp,
    QLImageTypeNone
} QLImageType;

typedef NS_ENUM(NSInteger, QLCurrentDeviceClass) {
    QLCurrentDeviceClass_iPhone,
    QLCurrentDeviceClass_iPhoneRetina,
    QLCurrentDeviceClass_iPhone5,
    QLCurrentDeviceClass_iPhone6,
    QLCurrentDeviceClass_iPhone6plus,
    
    // we can add new devices when we become aware of them
    
    QLCurrentDeviceClass_iPad,
    QLCurrentDeviceClass_iPadRetina,
    
    QLCurrentDeviceClass_unknown
};
@interface UIImage (QLImage)

/**
 *  @brief 根据self,返回一个按照最大比例切割出来的图片(就是根据比例从原图的中间切取最大的图片返回)
 *
 *  @param ratio 想要的比例(像素的宽/像素的高)
 *
 *  @return 返回一个按照最大比例切割出来的图片
 */
- (UIImage *)cutImageMaxWithRatio:(CGFloat)ratio;

- (UIImage *)compressImage:(UIImage *)image withSize:(CGSize )size;

- (UIImage *)captureView:(UIView *)theView;

- (UIImage *)scaleToSize:(CGSize)size;

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;

+ (UIImage *)imageWithName:(NSString *)strImgName;
+ (instancetype )imageForDeviceWithName:(NSString *)fileName;

@end
