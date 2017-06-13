//
//  UIImage+QLImage.m
//  MirePo
//
//  Created by ZhuoJing01 on 14/11/6.
//  Copyright (c) 2014年 ZhuoJing01. All rights reserved.
//

#import "UIImage+QLImage.h"
QLCurrentDeviceClass currentDeviceClass() {
    CGFloat greaterPixelDimension = (CGFloat)fmaxf(((float)[[UIScreen mainScreen]bounds].size.height),
                                                   ((float)[[UIScreen mainScreen]bounds].size.width));
    switch ((NSInteger)greaterPixelDimension) {
        case 480:
            return (( [[UIScreen mainScreen]scale] > 1.0) ? QLCurrentDeviceClass_iPhoneRetina : QLCurrentDeviceClass_iPhone );
            break;
            
        case 568:
            return QLCurrentDeviceClass_iPhone5;
            break;
            
        case 667:
            return QLCurrentDeviceClass_iPhone6;
            break;
            
        case 736:
            return QLCurrentDeviceClass_iPhone6plus;
            break;
            
        case 1024:
            return (( [[UIScreen mainScreen] scale] > 1.0) ? QLCurrentDeviceClass_iPadRetina : QLCurrentDeviceClass_iPad );
            break;
            
        default:
            return QLCurrentDeviceClass_unknown;
            break;
    }
}

@implementation UIImage (QLImage)

/**
 *  @brief 根据self,返回一个按照最大比例切割出来的图片
 *
 *  @param ratio 想要的比例(像素的宽/像素的高)
 *
 *  @return 返回一个按照最大比例切割出来的图片
 */
- (UIImage *)cutImageMaxWithRatio:(CGFloat)ratio {
    CGSize sizeImage = self.size;
    CGFloat fWidthRes;
    CGFloat fHeightRes;
    UIImage *image = [[UIImage alloc] init];
    
    if (sizeImage.width > sizeImage.height) {
        fWidthRes = sizeImage.height / ratio;
        CGFloat fXRes = (sizeImage.width - fWidthRes) / 2;
        CGRect rectRes = CGRectMake(fXRes, 0, fWidthRes, sizeImage.height);
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, rectRes)];
        return image;
    } else if (sizeImage.width < sizeImage.height) {
        fHeightRes = sizeImage.width * ratio;
        CGFloat fYRes = (sizeImage.height - fHeightRes) / 2;
        CGRect rectRes = CGRectMake(0, fYRes, sizeImage.width, fHeightRes);
        image = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(self.CGImage, rectRes)];
        return image;
    } else {
        return self;
    }
    return nil;
}

- (UIImage *)compressImage:(UIImage *)image withSize:(CGSize )size;
{    
    UIGraphicsBeginImageContext(size);
    CGRect rect = {{0,0}, size};
    [image drawInRect:rect];
    UIImage *compressedImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return compressedImg;
}

//处理view－>图片
- (UIImage *)captureView:(UIScrollView *)theView{
    CGSize size = theView.contentSize;
    //QLLog(@"captureViewSize:%@",NSStringFromCGSize(size));
    CGFloat fWidth = size.width;
    CGFloat fHeight = size.height;
    
    CGFloat radio = 720.0/fWidth;
    if (radio<1) {
        fHeight = radio*fHeight;
    }
    
    CGSize contextSize = CGSizeMake(720, fHeight);
    
    UIGraphicsBeginImageContext(contextSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}

- (UIImage*)scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context,并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *imgScaled = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return imgScaled;
}

//ImageType image_type(const char* path)
//{
//    ifstream inFile(path);
//    uchar png_type[9] = {0x89,0x50,0x4E,0x47,0x0D,0x0A,0x1A,0x0A,'/0'};
//    uchar file_head[9];
//    for (int i=0;i<8;++i)
//    {
//        inFile>>file_head[i];
//    }
//    file_head[8] = '/0';
//    switch (file_head[0])
//    {
//        case 0xff:
//            if (file_head[1]==0xd8)
//                return jpg;//jpeg
//        case 0x42:
//            if (file_head[1]==0x4D)
//                return bmp;//bmp
//        case 0x89:
//            if (file_head[1]==png_type[1] && file_head[2]==png_type[2] && file_head[3]==png_type[3] && file_head[4]==png_type[4]&&
//                file_head[5]==png_type[5] && file_head[6]==png_type[6] && file_head[7]==png_type[7])
//                return png;//png
//        default:
//            return nothing;  
//    }  
//}

QLImageType NSPUIImageTypeFromData(NSData *dataImage) {
    if (dataImage.length > 4) {
        const unsigned char * bytes = [dataImage bytes];
        if (bytes[0] == 0xff && bytes[1] == 0xd8 && bytes[2] == 0xff) {
            return QLImageTypeJpg;
        }
        if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4e && bytes[3] == 0x47) {
            return QLImageTypePng;
        }
    }
    return QLImageTypeNone;
}

//- (QLImageType)imageTypeWithImage:(UIImage *)image {
//    NSData *dataImage = ;
//    if (dataImage.length >4) {
//        const unsigned char * bytes = [dataImage bytes];
//        if (bytes[0] == 0xff && bytes[1] == 0xd8 && bytes[2] == 0xff) {
//            return QLImageTypeJpg;
//        }
//        if (bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4e && bytes[3] == 0x47) {
//            return QLImageTypePng;
//        }
//    }
//    return QLImageTypeNone;
//}

+ (UIImage *)imageWithName:(NSString *)strImgName {
    NSString *strElemment = @"@2x";
    NSString *strSuffix = @".png";
    if ([strImgName rangeOfString:strElemment].length != 0) {
        if ([strImgName hasSuffix:strSuffix]) {
            strImgName = [strImgName stringByReplacingOccurrencesOfString:strSuffix withString:@""];
        }
        strImgName = [NSString stringWithFormat:@"%@%@", strImgName, strElemment];
    }
    if (![strImgName hasSuffix:strSuffix]) {
        strImgName = [NSString stringWithFormat:@"%@%@", strImgName, strSuffix];
    }
    NSString *strImgPath = [[NSBundle mainBundle] pathForResource:strImgName ofType:nil];
    if (strImgPath == nil) {
        strImgName = [strImgName stringByReplacingOccurrencesOfString:@"@2x" withString:@""];
    }
    strImgPath = [[NSBundle mainBundle] pathForResource:strImgName ofType:nil];
    
    return [UIImage imageWithContentsOfFile:strImgPath];
}

+ (instancetype )imageForDeviceWithName:(NSString *)fileName {
    UIImage *result = nil;
    NSString *strImageName = [fileName stringByAppendingString:[UIImage magicSuffixForDevice]];
    
    result = [UIImage imageNamed:strImageName];
    if (!result) {
        result = [UIImage imageNamed:fileName];
    }
    return result;
}
+ (NSString *)magicSuffixForDevice {
    switch (currentDeviceClass()) {
        case QLCurrentDeviceClass_iPhone:
            return @"";
            break;
            
        case QLCurrentDeviceClass_iPhoneRetina:
            return @"@2x";
            break;
            
        case QLCurrentDeviceClass_iPhone5:
            return @"-568h@2x";
            break;
            
        case QLCurrentDeviceClass_iPhone6:
            return @"-667h@2x"; //or some other arbitrary string..
            break;
            
        case QLCurrentDeviceClass_iPhone6plus:
            return @"-736h@3x";
            break;
            
        case QLCurrentDeviceClass_iPad:
            return @"~ipad";
            break;
            
        case QLCurrentDeviceClass_iPadRetina:
            return @"~ipad@2x";
            break;
            
        case QLCurrentDeviceClass_unknown:
            
        default:
            return @"";
            break;
    }
}
@end
