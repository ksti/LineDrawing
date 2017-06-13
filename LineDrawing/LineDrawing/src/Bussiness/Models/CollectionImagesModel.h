//
//  CollectionImagesModel.h
//  LineDrawing
//
//  Created by forp on 16/7/5.
//  Copyright © 2016年 G. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  
 {
 CategoryID = 1;
 Content = "/images/20_0_20151212112831.jpg|/images/20_1_20151212112832.jpg|/images/20_2_20151212112832.jpg|/images/20_3_20151212112832.jpg|/images/20_4_20151212112832.jpg|/images/20_5_20151212112833.jpg|/images/20_6_20151212112833.jpg|/images/20_7_20151212112833.jpg";
 ContentPic = "<null>";
 ID = 20;
 Intime = "2015-12-10 22:14:17";
 PicNum = 8;
 ReadNum = "<null>";
 Title = "\U7ae0\U9c7c\U7b80\U7b14\U753b\U7684\U6b65\U9aa4\U56fe";
 }
 */

@interface CollectionImagesModel : NSObject

@property (nonatomic, copy) NSString *strID; // ID
@property (nonatomic, copy) NSString *strCategoryID; // CategoryID
@property (nonatomic, copy) NSString *strTitle; // Title
@property (nonatomic,readonly) NSString *strContent; // Content
@property (nonatomic,readonly) NSArray *arrContent; // Content
@property (nonatomic, copy) NSString *strContentPic; // ContentPic
@property (nonatomic,readonly) NSString *strPicNum; // PicNum
@property (nonatomic, copy) NSString *strReadNum; // ReadNum
@property (nonatomic,readonly) NSString *strIntime; // Intime

- (instancetype)initWithDictionary:(NSDictionary *)dicData;

@end
