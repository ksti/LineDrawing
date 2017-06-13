//
//  QLHttpTool.m
//  WorkAssistant
//
//  Created by macmini on 15/5/26.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#import "QLHttpTool.h"

@implementation QLHttpTool

/**
 *  向服务器发送普通的POST请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)postWithBaseUrl:(NSString *)strBaseUrl parameters:(NSDictionary *)dicParams withCookie:(id)cookie whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    if (cookie) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    [manager POST:strBaseUrl parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /** Save Cookie */
        NSDictionary *fields= [operation.response allHeaderFields];
        NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:strBaseUrl]];
        if (cookies.count) {
//            NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//            [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:USER_Cookies];
//            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

+ (void)postWithBaseUrl:(NSString *)strBaseUrl parameters:(NSDictionary *)dicParams formDatas:(NSArray *)arrDatas fileExtensions:(NSArray *)arrExtensions mimeTypes:(NSArray *)arrMimeTypes withCookie:(id)cookie whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (cookie) {
        [manager.requestSerializer setValue:cookie forHTTPHeaderField:@"Cookie"];
    }
    
    [manager POST:strBaseUrl parameters:dicParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //添加图片，并对其进行压缩（0.0为最大压缩率，1.0为最小压缩率）
        //UIImagePNGRepresentation(<#UIImage *image#>)
        //NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"图片名字（注意后缀名）"], 1.0);
        
        //添加要上传的文件，此处为图片
        //[formData appendPartWithFileData:imageData name:@"file(看上面接口，服务器放图片的参数名Key）" fileName:@"图片名字(随便写一个，（注意后缀名）如果是UIImagePNGRepresentation写XXXX.png,如果是UIImageJPEGRepresentation写XXXX.jpeg)" mimeType:@"文件类型（此处为图片格式，如image/jpeg，对应前面的PNG/JPEG）"];
        if (arrDatas && arrDatas.count > 0) {
            [arrDatas enumerateObjectsUsingBlock:^(NSData *data, NSUInteger idx, BOOL *stop) {
                NSDate *date = [NSDate date];
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"yyyy_MM_dd_HH_mm_ss";
                NSString *strPrefix = [formatter stringFromDate:date];
                NSString *strImageName = [NSString stringWithFormat:@"%@_%zi%@", strPrefix, idx, arrExtensions[idx]];
                [formData appendPartWithFileData:data name:@"file" fileName:strImageName mimeType:arrMimeTypes[idx]];
            }];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        /** Save Cookie */
//        if (isNeedCookie) {
//            NSDictionary *fields= [operation.response allHeaderFields];
//            NSArray *cookies=[NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:[NSURL URLWithString:strBaseUrl]];
//            if (cookies.count) {
//                NSDictionary* requestFields=[NSHTTPCookie requestHeaderFieldsWithCookies:cookies];
//                [[NSUserDefaults standardUserDefaults] setObject:[requestFields objectForKey:@"Cookie"] forKey:USER_Cookies];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//        }
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) { // 请求失败
        if (failure) {
            failure(operation, error);
        }
    }];
    
}

/**
 *  向服务器发送GET请求
 *
 *  @param strBaseUrl 接口地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)getWithBaseUrl:(NSString *)strBaseUrl parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObjectsFromSet:[NSSet setWithObjects:@"image/png", @"image/jpeg", @"image/jpg", nil]];
//    id cookie = [[NSUserDefaults standardUserDefaults] objectForKey:USER_Cookies];
//    if (cookie) {
//        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:USER_Cookies] forHTTPHeaderField:@"Cookie"];
//    }
    [manager GET:strBaseUrl parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

/**
 *  向服务器发送GET请求
 *
 *  @param strImageUrl 接口地址,专门处理图片地址
 *  @param dicParams  参数字典
 *  @param success    成功回调的Block
 *  @param failure    失败回调的Block
 */
+ (void)getWithImageUrl:(NSString *)strImageUrl parameters:(NSDictionary *)dicParams whenSuccess:(QLHttpToolSuccessBlock)success whenFailure:(QLHttpToolFailureBlock)failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFImageResponseSerializer serializer];
    //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"image/png", @"image/jpeg", @"image/jpg", nil];
//    id cookie = [[NSUserDefaults standardUserDefaults] objectForKey:USER_Cookies];
//    if (cookie) {
//        [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:USER_Cookies] forHTTPHeaderField:@"Cookie"];
//    }
    [manager GET:strImageUrl parameters:dicParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    UIViewController * vcCurrent = [self viewControllerOnly:result];
    return vcCurrent;
}
+ (UIViewController *)viewControllerOnly:(UIViewController *)vcOriginali{
    if ([vcOriginali isKindOfClass:[UINavigationController class]]) {
        UIViewController * vcLast;
        UINavigationController * nav = (UINavigationController *)vcOriginali;
        NSArray * arrVCs = nav.viewControllers;
        vcLast = [arrVCs lastObject];
        return [self viewControllerOnly:vcLast];
    }else if ([vcOriginali isKindOfClass:[UITabBarController class]]){
        UIViewController * vcLast;
        UITabBarController * vctab = (UITabBarController *)vcOriginali;
        vcLast = vctab.selectedViewController;
        return [self viewControllerOnly:vcLast];
    }else{
        return vcOriginali;
    }
}

@end
