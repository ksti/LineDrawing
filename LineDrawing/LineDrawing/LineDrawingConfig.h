//
//  LineDrawingConfig.h
//  LineDrawing
//
//  Created by forp on 16/7/5.
//  Copyright © 2016年 G. All rights reserved.
//

#ifndef LineDrawingConfig_h
#define LineDrawingConfig_h

/**
 * 服务器配置
 */
//
#if DEBUG
#define API_SERVER_URL @"http://4.77587.sinaapp.com"
#define API_IMAGES_URL @"https://sinacloud.net/lifency/childdraw"

#else
#define API_SERVER_URL @"http://4.77587.sinaapp.com"
#define API_IMAGES_URL @"https://sinacloud.net/lifency/childdraw"
#endif


/**
 * 接口配置
 */
//
#define API_CHILDDRAW_CATEGORY @"/childdraw/index.php"



/**
 * 存储常量
 */
//
#define CONFIG_SEARCH_HISTORY @"searchHistory" //搜索历史纪录
#define CONFIG_MYCATEGORY @"LineDrawing-MyCategory" //存储我的分类


/**
 * 统一样式
 */
//
#pragma mark - K color

//导航栏背景红色
#define KColorNavRed ColorFromHex(0xe24d47)

//统一的字体深灰色-标题字色
#define kColorTextGray ColorFromHex(0x444444)
//统一的字体浅灰-副标题字色
#define KColorTextLightGray ColorFromHex(0x999999)
//统一的字体黑色
#define kColorTextBlack ColorFromHex(0x000000)
//统一的字体蓝色
#define kColorTextBlue ColorFromHex(0x0099cc)
//统一背景灰色
#define kColorViewBgGray ColorFromHex(0xf6f6f6)//以下三种为同一色调，如果在tableView中用默认效果即可
//统一的分割线灰色
//#define kColorBorderGray ColorFromHex(0xf2f2f2)
#define kColorBorderGray ColorFromHex(0xe4e4e4)
//统一的选中灰色
#define kColorSelectedGray ColorFromHex(0xf2f2f2)
//统一的按钮背景灰
#define kColorBtnBgGray ColorFromHex(0xe4e4e4)
//边框色
#define kColorBorder ColorFromHex(0xdddddd)

//蓝
#define kColorBlue ColorFromHex(0x2dc3e8) //按钮蓝色可操作背景
#define kColorLightBlue ColorFromHex(0x9ae8fc)  //按钮淡蓝色背景（选中状态）

#define kColorRed ColorFromHex(0xf47172) //红色按钮可操作背景色

//统一的黄
#define kColorYellow ColorFromHex(0xff9900)
//统一的绿
#define kColorGreen ColorFromHex(0x009900)

#pragma mark - K size
//分割条高度
#define kHeightSeparateBar 15
//分割线高度
#define kHeightSeparateLine 1
//缩略图统一size
#define kSizeThumbnail  CGSizeMake(60, 60)




#endif /* LineDrawingConfig_h */
