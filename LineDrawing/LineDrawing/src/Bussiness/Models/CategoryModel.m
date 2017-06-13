//
//  CategoryModel.m
//  LineDrawing
//
//  Created by forp on 16/7/5.
//  Copyright © 2016年 G. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

/**
 *
 {
 "ID": "1",
 "Name": "动物简笔画",
 "ParentID": "0",
 "OrderID": 1,
 "Selected": "1",
 "Intime": "2015-12-07 22:13:45"
 },
 
 */

- (instancetype)initWithDictionary:(NSDictionary *)dicData
{
    if (self = [super init]) {
        _strID = [NSString getValidStringWithObject:dicData[@"ID"]];
        _strName = [NSString getValidStringWithObject:dicData[@"Name"]];
        _strParentID = [NSString getValidStringWithObject:dicData[@"ParentID"]];
        _strOrderID =[NSString getValidStringWithObject:dicData[@"OrderID"]];
        _strSelected = [NSString getValidStringWithObject:dicData[@"Selected"]];
        _strIntime =[NSString getValidStringWithObject:dicData[@"Intime"]];
        
    }
    return self;
}

@end
