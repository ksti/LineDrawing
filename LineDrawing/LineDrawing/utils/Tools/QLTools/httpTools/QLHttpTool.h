//
//  QLHttpTool.h
//  WorkAssistant
//
//  Created by macmini on 15/5/26.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "QLConst.h"
#import "SVProgressHUD.h"

typedef void(^QLHttpToolSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^QLHttpToolFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface QLHttpTool : NSObject

/**
 *  向服务器发送普通的POST请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)postWithBaseUrl:(NSString *)strBaseUrl parameters:(NSDictionary *)dicParams withCookie:(id)cookie whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;

+ (void)postWithBaseUrl:(NSString *)strBaseUrl parameters:(NSDictionary *)dicParams formDatas:(NSArray *)arrDatas fileExtensions:(NSArray *)arrExtensions mimeTypes:(NSArray *)arrMimeTypes withCookie:(id)cookie whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;

/**
 *  向服务器发送GET请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)getWithBaseUrl:(NSString *)strBaseUrl parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;

/**
 *  向服务器发送GET请求
 *
 *  @param strImageUrl 接口地址,专门处理图片地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)getWithImageUrl:(NSString *)strImageUrl parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure;

+ (UIViewController *)getCurrentVC;
@end
