//
//  QLAMRRecorder.m
//  QLAudioRecord
//
//  Created by Shrek on 15/9/9.
//  Copyright (c) 2015年 M. All rights reserved.
//

#import "QLAMRRecorder.h"
#import <AVFoundation/AVFoundation.h>

#import "MLAudioRecorder.h"
#import "AmrRecordWriter.h"
#import "MLAudioMeterObserver.h"

@interface QLAMRRecorder () {
    BOOL dliver;
}

@property (nonatomic, strong) MLAudioRecorder *recorder;
@property (nonatomic, strong) AmrRecordWriter *amrWriter;
@property (nonatomic, strong) AVAudioPlayer *player;

@property (nonatomic, copy) NSString *filePath;
@property (nonatomic, strong) MLAudioMeterObserver *meterObserver;

@end

@implementation QLAMRRecorder

- (instancetype)init {
    if (self = [super init]) {
        _timeCount = 0;
        _recordTime = 0;
        dliver = NO;
        [self loadDefaultSetting];
    }
    return self;
}

#pragma mark - Load default UI and Data
- (void)loadDefaultSetting {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    // AMR写入器
    AmrRecordWriter *amrWriter = [[AmrRecordWriter alloc] init];
    amrWriter.filePath = [path stringByAppendingPathComponent:@"record.amr"];
    NSLog(@"%@", amrWriter.filePath);
//    amrWriter.maxSecondCount = 60;
    amrWriter.maxSecondCount = 63;
    amrWriter.maxFileSize = 1024*256;
    amrWriter.cafFilePath = [path stringByAppendingPathComponent:@"recordAmr.caf"];
    self.amrWriter = amrWriter;
    
    // 测量监视器
    MLAudioMeterObserver *meterObserver = [[MLAudioMeterObserver alloc]init];
    meterObserver.actionBlock = ^(NSArray *levelMeterStates,MLAudioMeterObserver *meterObserver){
        _timeCount++;
        _recordTime = meterObserver.timer.timeInterval*_timeCount;
        if ([self.delegate respondsToSelector:@selector(amrRecorder:recordTime:volume:)]) {
            [self.delegate amrRecorder:self recordTime:_recordTime volume:[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]];
        }
        
        //        NSLog(@"volume:%f",[MLAudioMeterObserver volumeForLevelMeterStates:levelMeterStates]);
        
    };
    
    meterObserver.errorBlock = ^(NSError *error,MLAudioMeterObserver *meterObserver){
        if ([self.delegate respondsToSelector:@selector(amrRecorder:FailedWithError:)]) {
            [self.delegate amrRecorder:self FailedWithError:error];
        }
    };
    self.meterObserver = meterObserver;
    
    __weak typeof(self) selfWeak = self;
    
    // 录音器
    MLAudioRecorder *recorder = [[MLAudioRecorder alloc] init];
    recorder.receiveStoppedBlock = ^{
        self.meterObserver.audioQueue = nil;
        [self deliver];
    };
    recorder.receiveErrorBlock = ^(NSError *error){
        self.meterObserver.audioQueue = nil;
        if ([self.delegate respondsToSelector:@selector(amrRecorder:FailedWithError:)]) {
            [self.delegate amrRecorder:selfWeak FailedWithError:error];
        }
    };
    
    //amr
    recorder.bufferDurationSeconds = 0.04;
    recorder.fileWriterDelegate = amrWriter;
    self.filePath  = amrWriter.cafFilePath;
    
    self.recorder = recorder;
}

- (void)record {
    _timeCount = 0;
    _recordTime = 0;
    if (self.recorder.isRecording == NO) {
        //开始录音
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *strFileName = [NSString stringWithFormat:@"%@.amr", [formatter stringFromDate:[NSDate date]]];
        self.amrWriter.filePath = [path stringByAppendingPathComponent:strFileName];
        [self.recorder startRecording];
        self.meterObserver.audioQueue = self.recorder->_audioQueue;
        
    }
}

- (void)recordToFilePath:(NSString *)filePath fileName:(NSString *)fileName {
    _timeCount = 0;
    _recordTime = 0;
    if (self.recorder.isRecording == NO) {
        //开始录音
        self.amrWriter.filePath = [filePath stringByAppendingPathComponent:fileName];
        self.amrWriter.cafFilePath = [filePath stringByAppendingPathComponent:@"recordAmr.caf"];
        self.filePath = self.amrWriter.cafFilePath;
        [self.recorder startRecording];
        self.meterObserver.audioQueue = self.recorder->_audioQueue;
        
    }
}

- (void)stop {
    _timeCount = 0;
    _recordTime = 0;
    self.meterObserver.audioQueue = nil;//停止测量
    if (self.recorder.isRecording) {
        //停止录音
        [self.recorder stopRecording];
        
        /*
        if ([self.delegate respondsToSelector:@selector(amrRecorder:DidFinishRecordWithFilePath:)]) {
            [self.delegate amrRecorder:self DidFinishRecordWithFilePath:_amrWriter.filePath];
        }
        */
    }
}

- (void)deliver {
    _timeCount = 0;
    _recordTime = 0;
    self.meterObserver.audioQueue = nil;//停止测量
    if ([self.delegate respondsToSelector:@selector(amrRecorder:DidFinishRecordWithFilePath:)]) {
        [self.delegate amrRecorder:self DidFinishRecordWithFilePath:_amrWriter.filePath];
    }
}

- (void)cancel {
    _timeCount = 0;
    _recordTime = 0;
    self.meterObserver.audioQueue = nil;//停止测量
    if (self.recorder.isRecording) {
        [self.recorder stopRecording];
        if ([self.delegate respondsToSelector:@selector(amrRecorderDidCancel:)]) {
            [self.delegate amrRecorderDidCancel:self];
        }
    }
}

- (void)play {
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:self.filePath] error:nil];
    [self.player prepareToPlay];
    [self.player play];
}

- (void)dealloc {
    //音谱检测关联着录音类，录音类要停止了。所以要设置其audioQueue为nil
    self.meterObserver.audioQueue = nil;
    [self.recorder stopRecording];
}

@end
