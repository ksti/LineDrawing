//
//  GlobalUtil.m
//  eForp
//
//  Created by xdforp on 14-7-10.
//
//

#define DEFAULT_VOID_COLOR [UIColor whiteColor]

#import "GlobalUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImageView+WebCache.h"

#import <objc/runtime.h>// 导入运行时文件

@implementation GlobalUtil

//字符串转颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    
    if ([cString length] < 6)
        return DEFAULT_VOID_COLOR;
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return DEFAULT_VOID_COLOR;
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+(void)showMessage:(NSString*)msg{
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:NULL cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [av show];
}


+(BOOL)isEmpty:(NSString*)value{
    return [[value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0?YES:NO;
}

+(NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];//转换成utf-8
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法
     把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}

+(NSString*)getNowDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@""] ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return  [dateFormatter stringFromDate:[NSDate date]];
}

+(void)showUILocalNotification:(NSString*)content{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSLog(@">> support local notification");
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:0.1];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=content;
        notification.soundName= UILocalNotificationDefaultSoundName;
        [[UIApplication sharedApplication]   scheduleLocalNotification:notification];
    }
}

+(void)showUILocalNotification:(NSString*)content WithUserInfo:(NSDictionary *)userInfo{
    UILocalNotification *notification=[[UILocalNotification alloc] init];
    if (notification!=nil) {
        NSLog(@">> support local notification");
        NSDate *now=[NSDate new];
        notification.fireDate=[now dateByAddingTimeInterval:0.1];
        notification.timeZone=[NSTimeZone defaultTimeZone];
        notification.alertBody=content;
        notification.soundName= UILocalNotificationDefaultSoundName;
        notification.userInfo=userInfo;
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

#pragma mark -
#pragma mark 等比縮放image
+ (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width*scaleSize, image.size.height*scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

#pragma arguments
#pragma mark -拨打电话
+(void)CallPhone:(NSString*)phone{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",phone]]];
}
//====
+ (NSData *)dataFromAsset:(ALAsset *)asset assetRepresentation:(ALAssetRepresentation *)assetRep {
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    if (assetRep) {
        rep = assetRep;
    }
    Byte *buffer = (Byte*)malloc(rep.size);
    NSUInteger buffered = [rep getBytes:buffer fromOffset:0.0 length:rep.size error:nil];
    NSData *data = [NSData dataWithBytesNoCopy:buffer length:buffered freeWhenDone:YES];
    return data;
}

+ (BOOL)writeDataToPath:(NSString*)filePath andAsset:(ALAsset*)asset
{
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
    if (!handle) {
        return NO;
    }
    static const NSUInteger BufferSize = 1024*1024;
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    uint8_t *buffer = calloc(BufferSize, sizeof(*buffer));
    NSUInteger offset = 0, bytesRead = 0;
    do {
        @try {
            bytesRead = [rep getBytes:buffer fromOffset:offset length:BufferSize error:nil];
            [handle writeData:[NSData dataWithBytesNoCopy:buffer length:bytesRead freeWhenDone:NO]];
            offset += bytesRead;
        } @catch (NSException *exception) {
            free(buffer);
            return NO;
        }
    } while (bytesRead > 0);
    free(buffer);
    return YES;
}

+ (NSData *)cacheDataFromUrl:(NSString *)imageURL {
    NSData *imageData = nil;
    BOOL isExit = [[SDWebImageManager sharedManager] diskImageExistsForURL:[NSURL URLWithString:imageURL]];
    if (isExit) {
        NSString *cacheImageKey = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:imageURL]];
        if (cacheImageKey.length) {
            NSString *cacheImagePath = [[SDImageCache sharedImageCache] defaultCachePathForKey:cacheImageKey];
            if (cacheImagePath.length) {
                imageData = [NSData dataWithContentsOfFile:cacheImagePath];
            }
        }
    }
    if (!imageData) {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    }
    return imageData;
}

//返回类的所有属性
+ (NSArray *)getProperties:(Class)cls {
    
    // 获取当前类的所有属性
    unsigned int count;// 记录属性个数
    objc_property_t *properties = class_copyPropertyList(cls, &count);
    // 遍历
    NSMutableArray *mArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        
        // An opaque type that represents an Objective-C declared property.
        // objc_property_t 属性类型
        objc_property_t property = properties[i];
        // 获取属性的名称 C语言字符串
        const char *cName = property_getName(property);
        // 转换为Objective C 字符串
        NSString *name = [NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
        [mArray addObject:name];
    }
    
    return mArray.copy;
}

#pragma mark 数组排序1
+ (NSArray *)arraySort1:(NSArray *)array objectClass:(Class)objectClass orderBy:(NSString *)property {
    
    NSArray *properties = [GlobalUtil getProperties:objectClass];
    if (![properties containsObject:property]) {
        return array;
    }
    
    //NSArray *array2 = [array sortedArrayUsingSelector:@selector(compare:)];
    NSArray *array2 = [array sortedArrayUsingComparator:
                       ^NSComparisonResult(id obj1, id obj2) {
                           // 按照property排序
                           NSComparisonResult result = [[obj1 valueForKey:property] compare:[obj2 valueForKey:property]];
                           /*
                            if (result == NSOrderedAscending) {
                            result = NSOrderedDescending;//倒序
                            }
                            */
                           
                           return result;
                       }];
    
    return array2;
}

#pragma mark viewFromNib
+ (UIView *)extractFromXib:(NSString *)viewName
{
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:viewName owner:nil options:nil];
    Class targetClass = NSClassFromString(viewName);
    for (UIView *view in views) {
        if ([view isMemberOfClass:targetClass]) {
            return view;
        }
    }
    return nil;
    
}


@end

@implementation FileUtil

/*文件是否存在*/
+ (BOOL)isFileExisted:(NSString *)fileName{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:[self getFilePath:fileName]]){
        return NO;
    }
    
    return YES;
}

/*创建指定名字的文件*/
+ (BOOL)createFileAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"-----%@:", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        [fileManager createFileAtPath:path contents:nil attributes:nil];
        return YES;
    }
    
    return NO;
}

/*创建指定名字的文件夹*/
+ (BOOL)createDirectoryAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSLog(@"-----%@:", path);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if(![fileManager fileExistsAtPath:path]){
        NSError *error = nil;
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        return YES;
    }
    
    return NO;
}

/*得到文件路径*/
+ (NSString *)getFilePath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    
    return path;
}

/*删除文件*/
+ (BOOL)deleteFileAtPath:(NSString *)fileName{
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[array objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if(![fileManager fileExistsAtPath:path]){
        return NO;
    }
    
    [fileManager removeItemAtPath:path error:nil];
    return YES;
}

/*得到PList文件*/
+ (NSMutableDictionary *)getPlistFile:(NSString *)fileName{
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *path = [bundle pathForResource:fileName ofType:@"plist"];
    
    return [[NSMutableDictionary alloc] initWithContentsOfFile:path];
}

/*获取plist文件目录*/
+ (NSString *)getPListFilePath:(NSString *)fileName{
    NSBundle *bundle = [NSBundle mainBundle];
    return [bundle pathForResource:fileName ofType:@"plist"];
}

@end
