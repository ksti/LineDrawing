//
//  MHDebugLog.h
//  Blue-V
//  
//  Created by mac on 14-3-28.
//  Copyright (c) 2014年 lena. All rights reserved.
//

#if TARGET_IPHONE_SIMULATOR
#define DebugLog(log, ...) NSLog((@"%s [Line %d] " log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DebugLog(log, ...) NSLog((@"ipod= %s [Line %d] " log), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif