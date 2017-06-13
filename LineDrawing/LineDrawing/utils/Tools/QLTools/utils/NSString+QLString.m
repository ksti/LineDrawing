//
//  NSString+QLString.m
//  WorkAssistant
//
//  Created by Shrek on 15/5/29.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import "NSString+QLString.h"

@implementation NSString (QLString)

- (unsigned long long)unsignedLongLongValue {
    return strtoull([self UTF8String], NULL, 0);
}

+ (instancetype)getValidStringWithObject:(id)obj {
    /**
     *  nil->(null)
     *  NSNull-><null>
     */
    if ([obj isKindOfClass:[NSString class]]) {
        NSString *strValue = obj;
        if (strValue && ![strValue isEqualToString:@"<null>"] && ![strValue isEqualToString:@"(null)"] && ![strValue isEqualToString:@""]) {
            return strValue;
        } else {
            return @"";
        }
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@", obj];
    } else {
        return @"";
    }
}
+(NSString *)appendStringFromDictionary:(id )dicData{
    if ([dicData isKindOfClass:[NSDictionary class]]) {
        NSMutableString * strData = [NSMutableString stringWithString:@"{"];
        for (NSString * key in dicData) {
            id data = dicData[key];
            if (strData.length==1) {
                if ([data isKindOfClass:[NSDictionary class]]) {
                    [strData appendFormat:@"\"%@\":%@",key,[NSString appendStringFromDictionary:data]];
                }else{
                    [strData appendFormat:@"\"%@\":\"%@\"",key,[NSString appendStringFromDictionary:data]];
                }
            }else{
                if ([data isKindOfClass:[NSDictionary class]]) {
                    [strData appendFormat:@",\"%@\":%@",key,[NSString appendStringFromDictionary:data]];
                }else{
                    [strData appendFormat:@",\"%@\":\"%@\"",key,[NSString appendStringFromDictionary:data]];
                }
                
            }
        }
        [strData appendString:@"}"];
        return strData;
    }else if([dicData isKindOfClass:[NSString class]]){
        return dicData;
    }else if([dicData isKindOfClass:[NSNumber class]]){
        NSNumber * numberData = (NSNumber *)dicData;
        return [NSString stringWithFormat:@"%zd",[numberData integerValue]];
    }else{
        NSLog(@"ASI其它形式的数据:%@",[dicData class]);
        return @"";
    }
}
- (BOOL)isEmptyString {
    if ([self isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSArray *)arrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return array;
}

+ (NSString *)jsonStringWithNSDictionary:(NSDictionary *)dict{
    NSData *dataJson = [NSString jsonDataWithNSDictionary:dict];
    NSString *strJson = [[NSString alloc] initWithData:dataJson encoding:NSUTF8StringEncoding];
    return strJson;
}
#pragma mark  jsonString 替换方法
+(NSString*)dataTOjsdonString:(id)object{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

+ (NSData *)jsonDataWithNSDictionary:(NSDictionary *)dict{
    NSError *error = nil;
    NSData *dataJson = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
    if(error) {
        NSLog(@"Serialization Eror: %@",error);
        NSAssert(0>1, @"解析JSONObject出错");
        return nil;
    } else {
        //QLLog(@"Serialization body: %@",dict);
        return dataJson;
    }
}

+(BOOL)isValidatePhone:(NSString *) _phone {
    NSString *emailRegex = @"^(0?1[0-9]\\d{9})$|^((0(10|2[1-3]|[3-9]\\d{2}))-?[1-9]\\d{6,7})$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:_phone];
}
//邮箱
+ (BOOL) isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}
#pragma mark - date
+ (NSDate *)dateFromString:(NSString *)dateString{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm"];
    
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    return destDate;
    
}
+ (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    NSString *destDateString = [dateFormatter stringFromDate:date];
    
    return destDateString;
}
- (NSString *)stringChangeDateSeparateByLineToText{
    if (self.length !=16) {
        NSLog(@"传入的数据格式不符合要求");
        return self;
    }else{
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        NSDate *destDate= [dateFormatter dateFromString:self];
        
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
        NSString *strRevert = [dateFormatter stringFromDate:destDate];
        
        return strRevert;
    }
}

@end
