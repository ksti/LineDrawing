//
//  QLAMRPlayer.h
//  QLAudioRecord
//
//  Created by Shrek on 15/9/9.
//  Copyright (c) 2015年 M. All rights reserved.
//

//使用AudioQueue来实现音频播放功能时最主要的步骤:
//1. 打开播放音频文件
//2. 取得或设置播放音频文件的数据格式
//3. 建立播放用的队列
//4. 将缓冲中的数据填充到队列中
//5. 开始播放
//6. 在回调函数中进行队列处理

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AudioToolbox/AudioFile.h>
#import <MediaPlayer/MediaPlayer.h>

@class AVAudioPlayer;
@interface QLAMRPlayer : NSObject
@property (strong, nonatomic) AVAudioPlayer *player;
@property (strong, nonatomic) UIButton *switchAudioSessionCategory;

//播放方法定义
//- (void)play:(NSString *)path;
- (void)playFromLocalPath:(NSString *)path;
- (void)playFromData:(NSData *)data;
- (void)playFromData:(NSData *)data saveFileName:(NSString*)fileName;
- (void)playFromUrl:(NSURL *)url saveFileName:(NSString*)fileName;

//获取播放时长
- (NSInteger)voiceLengthFromData:(NSData *)data;

@end
