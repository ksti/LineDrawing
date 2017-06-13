//
//  QLConst.m
//  WorkAssistant
//
//  Created by macmini on 15/5/26.
//  Copyright (c) 2015年 com.homelife.manager.mobile. All rights reserved.
//

#ifdef DEBUG

NSString * const strBaseUrl = @"http://192.168.100.61";
NSString * const QLBaseUrl_Training = @"http://123.56.109.242/training";
NSString * const QLBaseUrl_WorkingAssistance = @"http://123.56.109.242/working";
NSString * const QLBaseUrl_MainStrlSys = @"http://123.56.109.242/mcs";

NSString * const QLBaseUrl_Test = @"http://192.168.100.68/zsmcs";
NSString * const QLUrlPath_Test = @"/Handlers/MidApi.ashx";

#else

NSString * const strBaseUrl = @"http://192.168.100.61";
NSString * const QLBaseUrl_Training = @"http://123.56.109.242/training";
NSString * const QLBaseUrl_WorkingAssistance = @"http://123.56.109.242/working";
NSString * const QLBaseUrl_MainStrlSys = @"http://123.56.109.242/mcs";

NSString * const QLBaseUrl_Test = @"http://192.168.100.68/zsmcs";
NSString * const QLUrlPath_Test = @"/Handlers/MidApi.ashx";

#endif

NSString * const QLAppType_WorkingOnline = @"1";
//NSString * const QLNotificationRegisterDidSuccess = @"QLNotificationRegisterDidSuccess";

NSString * const QLNotificationNewRegisterDidSuccess = @"QLNotificationNewRegisterDidSuccess";
NSString * const QLNotificationNewRegisterDidFailure = @"QLNotificationNewRegisterDidFailure";
NSString * const QLNotificationJoinRegisterDidSuccess = @"QLNotificationJoinRegisterDidSuccess";
NSString * const QLNotificationJoinRegisterDidFailure = @"QLNotificationJoinRegisterDidFailure";

/** 用户cookie key */
NSString * const QLUser_Cookies = @"QLUser_Cookies";

/** 服务器配置地址 */
NSString * const QLServerUrlKey = @"QLServerUrlKey";
