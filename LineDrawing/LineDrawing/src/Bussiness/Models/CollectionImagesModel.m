//
//  CollectionImagesModel.m
//  LineDrawing
//
//  Created by forp on 16/7/5.
//  Copyright © 2016年 G. All rights reserved.
//

#import "CollectionImagesModel.h"

@implementation CollectionImagesModel

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

- (instancetype)initWithDictionary:(NSDictionary *)dicData
{
    if (self = [super init]) {
        _strID = [NSString getValidStringWithObject:dicData[@"ID"]];
        _strCategoryID = [NSString getValidStringWithObject:dicData[@"CategoryID"]];
        _strTitle = [NSString getValidStringWithObject:dicData[@"Title"]];
        _strContent = [NSString getValidStringWithObject:dicData[@"Content"]];
        _arrContent = [_strContent componentsSeparatedByString:@"|"];
        _strContentPic = [NSString getValidStringWithObject:dicData[@"ContentPic"]];
        _strPicNum = [NSString getValidStringWithObject:dicData[@"PicNum"]];
        _strReadNum = [NSString getValidStringWithObject:dicData[@"ReadNum"]];
        _strIntime =[NSString getValidStringWithObject:dicData[@"Intime"]];
        
    }
    return self;
}

@end
