//
//  GlobalUtil.h
//
//  定义全局方法
//  Created by xdforp on 14-7-10.
//
//

/** DEBUG Print | M:method, L:line, C:content*/
#ifdef DEBUG
#define DebugLog(FORMAT, ...) fprintf(stderr,"M:%s|L:%d|C->%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define DebugLog(FORMAT, ...)
//#define DebugLog(FORMAT, ...) fprintf(stderr,"M:%s|L:%d|C->%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#endif

/** ScreenSize */
#ifndef ScreenSize
#define ScreenSize [UIScreen mainScreen].bounds.size
#endif

#ifndef ScreenWidth
#define ScreenWidth ScreenSize.width
#endif

#ifndef ScreenHeight
#define ScreenHeight ScreenSize.height
#endif

#ifndef DefaultNotificationCenter
#define DefaultNotificationCenter [NSNotificationCenter defaultCenter]
#endif

#ifndef ValueFromUserDefaults
#define ValueFromUserDefaults(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#endif

#ifndef ColorWithRGB
#define ColorWithRGB(redValue, greenValue, blueValue) ([UIColor colorWithRed:((redValue)/255.0) green:((greenValue)/255.0) blue:((blueValue)/255.0) alpha:1])
#endif

#ifndef ColorFromHex
#define ColorFromHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#endif

#ifndef ColorRandom
#define ColorRandom ColorWithRGB(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#endif

#ifndef IOS_VERSION_7_OR_ABOVE
#define IOS_VERSION_7_OR_ABOVE (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (YES):(NO))
#endif

@class ALAsset;
@class ALAssetRepresentation;
@interface GlobalUtil : NSObject

+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;//字符串转颜色
+(void)showMessage:(NSString*)msg;
+(BOOL)isEmpty:(NSString*)value;//是否为空或者全部为空格
+(NSString *)md5:(NSString *)str ;

+(NSString*)getNowDate;
+(void)showUILocalNotification:(NSString*)content;
+(void)showUILocalNotification:(NSString*)content WithUserInfo:(NSDictionary *)userInfo;
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize;
+(void)CallPhone:(NSString*)phone;

//从相册加载数据
+ (NSData *)dataFromAsset:(ALAsset *)asset assetRepresentation:(ALAssetRepresentation *)assetRep;
+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset;

//取缓存图片
+ (NSData *)cacheDataFromUrl:(NSString *)imageURL;

//返回类的所有属性
+ (NSArray *)getProperties:(Class)cls;

//数组排序1
+ (NSArray *)arraySort1:(NSArray *)array objectClass:(Class)objectClass orderBy:(NSString *)property;

//viewFromNib
+ (UIView *)extractFromXib:(NSString *)viewName;

@end

@interface FileUtil : NSObject

/*文件是否存在*/
+ (BOOL)isFileExisted:(NSString *)fileName;
/*创建指定名字的文件*/
+ (BOOL)createFileAtPath:(NSString *)fileName;
/*创建指定名字的文件夹*/
+ (BOOL)createDirectoryAtPath:(NSString *)fileName;
/*得到文件路径*/
+ (NSString *)getFilePath:(NSString *)fileName;
/*删除文件*/
+ (BOOL)deleteFileAtPath:(NSString *)fileName;
/*得到PList文件*/
+ (NSMutableDictionary *)getPlistFile:(NSString *)fileName;
@end


