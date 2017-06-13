//
//  QLAMRPlayer.m
//  QLAudioRecord
//
//  Created by Shrek on 15/9/9.
//  Copyright (c)2015年 M. All rights reserved.
//

#import "QLAMRPlayer.h"
#import "VoiceConverter.h"
#import <AVFoundation/AVFoundation.h>

@interface QLAMRPlayer ()<AVAudioPlayerDelegate>

//@property (strong, nonatomic) AVAudioPlayer *player;

@end

@implementation QLAMRPlayer

- (instancetype)init {
    if (self = [super init]) {
        [self initSet];
    }
    return self;
}

- (void)playFromLocalPath:(NSString *)path {
    if (path == nil) return;
    NSString *pathWave = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.wav"];
    if ([VoiceConverter ConvertAmrToWav:path wavSavePath:pathWave]){
        NSLog(@"%@", pathWave);
        NSError *playerError;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathWave] error:&playerError];
        
        
        player.meteringEnabled = YES;
        player.delegate = self;
        
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        
        [self handleNotification:YES];
        [player prepareToPlay];
        [player play];
        self.player = player;
    }
}

- (void)playFromData:(NSData *)data {
    if (data.length <= 0) return;
    NSString *pathWave = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.wav"];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.amr"];
    [data writeToFile:path atomically:YES];
    if ([VoiceConverter ConvertAmrToWav:path wavSavePath:pathWave]){
        NSLog(@"%@", pathWave);
        NSError *playerError;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathWave] error:&playerError];
        
        
        player.meteringEnabled = YES;
        player.delegate = self;
        
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        
        [self handleNotification:YES];
        [player prepareToPlay];
        [player play];
        self.player = player;
    }
}

- (NSInteger)voiceLengthFromData:(NSData *)data {
    //QLLog(@"----- data: ----- \n %@ \n",data);
    if (data.length <= 0) return 0;
    NSString *pathWave = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.wav"];
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.amr"];
    [data writeToFile:path atomically:YES];
    if ([VoiceConverter ConvertAmrToWav:path wavSavePath:pathWave]){
        NSLog(@"%@", pathWave);
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathWave] error:nil];
//        [player prepareToPlay];
//        [player play];
//        self.player = player;
        return (NSInteger)player.duration;
    }
    return 0;
}


- (void)playFromUrl:(NSURL *)url saveFileName:(NSString*)fileName{
    __block NSData *data = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        data = [NSData dataWithContentsOfURL:url];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data.length <= 0) return;
            NSString *pathWave = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.wav"];
            
            //    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.amr"];
            NSString *path = nil;
            if (fileName) {
                path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
            }
            else {
                path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.amr"];
            }
            [data writeToFile:path atomically:YES];
            if ([VoiceConverter ConvertAmrToWav:path wavSavePath:pathWave]){
                NSLog(@"%@", pathWave);
                NSError *playerError;
                AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathWave] error:&playerError];
                
                
                player.meteringEnabled = YES;
                player.delegate = self;
                
                
                if (player == nil)
                {
                    NSLog(@"ERror creating player: %@", [playerError description]);
                }
                
                [self handleNotification:YES];
                [player prepareToPlay];
                [player play];
                self.player = player;
            }
        });
    });
}

- (void)playFromData:(NSData *)data saveFileName:(NSString*)fileName{
    if (data.length <= 0) return;
    NSString *pathWave = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.wav"];
    
//    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.amr"];
    NSString *path;
    if (fileName) {
        path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:fileName];
    }
    else {
        path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"test.amr"];
    }
    [data writeToFile:path atomically:YES];
    if ([VoiceConverter ConvertAmrToWav:path wavSavePath:pathWave]){
        NSLog(@"%@", pathWave);
        NSError *playerError;
        AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathWave] error:&playerError];
        
        
        player.meteringEnabled = YES;
        player.delegate = self;
        
        
        if (player == nil)
        {
            NSLog(@"ERror creating player: %@", [playerError description]);
        }
        
        [self handleNotification:YES];
        [player prepareToPlay];
        [player play];
        self.player = player;
    }
}

- (void)initSet
{
    //初始化播放器的时候如下设置
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
                            sizeof(sessionCategory),
                            &sessionCategory);
    
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
                             sizeof (audioRouteOverride),
                             &audioRouteOverride);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //默认情况下扬声器播放
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    [audioSession setActive:YES error:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放结束");
    [self handleNotification:NO];
    if (self.switchAudioSessionCategory) {
        [self.switchAudioSessionCategory setHidden:YES];
    }
}

#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    if(state)//添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    else//移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification;
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}


@end