//
//  NSString+QLString.h
//  WorkAssistant
//
//  Created by Shrek on 15/5/29.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (QLString)

- (unsigned long long)unsignedLongLongValue;
/** 对请求结果进行容错处理 */
+ (instancetype)getValidStringWithObject:(id)obj;
/** 判空字符串 */
- (BOOL)isEmptyString;

/** 将json转为字典或数组 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString;

//将对象转换为json
//+ (NSData *)jsonDataWithNSDictionary:(NSDictionary *)dict;
+(NSString*)dataTOjsdonString:(id)object;
/** 将字典拼接成字符串 */
+ (NSString *)jsonStringWithNSDictionary:(NSDictionary *)dict;
+(NSString *)appendStringFromDictionary:(id )dicData;

/** 判断是否是有效的电话号码 */
+(BOOL)isValidatePhone:(NSString *) _phone;
+(BOOL)isValidateEmail:(NSString *)email;


//字符串转换为date时间－yyyy-MM-dd HH:mm格式
+ (NSDate *)dateFromString:(NSString *)dateString;
/** date转换为字符串－yyyy-MM-dd HH:mm格式 */
+ (NSString *)stringFromDate:(NSDate *)date;

/** 日期从yyyy-MM-dd HH:mm转换为以yyyy年MM月dd日 HH:mm分割 */
- (NSString *)stringChangeDateSeparateByLineToText;
@end
