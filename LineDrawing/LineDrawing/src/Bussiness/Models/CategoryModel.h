//
//  CategoryModel.h
//  LineDrawing
//
//  Created by forp on 16/7/5.
//  Copyright © 2016年 G. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryModel : NSObject

@property (nonatomic, copy) NSString *strID; // ID
@property (nonatomic, copy) NSString *strName; // Name
@property (nonatomic, copy) NSString *strParentID; // ParentID
@property (nonatomic,readonly) NSString *strOrderID; // OrderID
@property (nonatomic, copy) NSString *strSelected; // Selected
@property (nonatomic,readonly) NSString *strIntime; // Intime

- (instancetype)initWithDictionary:(NSDictionary *)dicData;

@end
