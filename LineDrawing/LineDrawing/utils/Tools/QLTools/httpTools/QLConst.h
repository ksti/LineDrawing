//
//  QLConst.h
//  WorkAssistant
//
//  Created by macmini on 15/5/26.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

typedef enum {
    QLTurningOnTypeNone,
    QLTurningOnTypeNew,
    QLTurningOnTypeJoin
}QLTurningOnType;

typedef enum {
    QLRegisterTypeNeverRegister = -1, // 此手机号从未注册过，可继续注册
    QLRegisterTypeRegisteredButNotFinished = 0, // 此手机号已经注册过企业但未完成，可继续注册
    QLRegisterTypeRegistered  // 此手机号已经注册成功，不可以继续注册
} QLRegisterType;

#define QLHasRequestSuccess (![responseObject[@"Code"] boolValue])
#define QLColor_Red QLColorWithRGB(226, 77, 71)

#ifdef DEBUG
extern NSString * const strBaseUrl;
extern NSString * const QLBaseUrl_Training; // 培训系统
extern NSString * const QLBaseUrl_WorkingAssistance; // 工作助手
extern NSString * const QLBaseUrl_MainStrlSys; // 主控系统

//#warning 临时的是什么意思？上架要换吗？
extern NSString * const QLBaseUrl_Test; // 临时的接口
extern NSString * const QLUrlPath_Test; // 临时UrlPath

#else 

extern NSString * const strBaseUrl;
extern NSString * const QLBaseUrl_Training; // 培训系统
extern NSString * const QLBaseUrl_WorkingAssistance; // 工作助手
extern NSString * const QLBaseUrl_MainStrlSys; // 主控系统

#warning 临时的是什么意思？上架要换吗？暂时加在了这里
extern NSString * const QLBaseUrl_Test; // 临时的接口
extern NSString * const QLUrlPath_Test; // 临时UrlPath
#endif

extern NSString * const QLAppType_WorkingOnline;  // 职场在线Apptype
//extern NSString * const QLNotificationRegisterDidSuccess;
extern NSString * const QLNotificationNewRegisterDidSuccess;
extern NSString * const QLNotificationNewRegisterDidFailure;
extern NSString * const QLNotificationJoinRegisterDidSuccess;
extern NSString * const QLNotificationJoinRegisterDidFailure;

/** 用户cookie key */
extern NSString * const QLUser_Cookies;

/** 服务器配置地址 */
extern NSString * const QLServerUrlKey;
