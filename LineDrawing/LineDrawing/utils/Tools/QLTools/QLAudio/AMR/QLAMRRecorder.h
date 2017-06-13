//
//  QLAMRRecorder.h
//  QLAudioRecord
//
//  Created by Shrek on 15/9/9.
//  Copyright (c) 2015年 M. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLAMRRecorderDelegate;

@interface QLAMRRecorder : NSObject

@property (nonatomic, weak) id<QLAMRRecorderDelegate> delegate;
@property (assign, nonatomic, readonly) double timeCount;
@property (assign, nonatomic, readonly) double recordTime;

- (void)record;
- (void)recordToFilePath:(NSString *)filePath fileName:(NSString *)fileName;
- (void)stop;
- (void)cancel;

@end

@protocol QLAMRRecorderDelegate <NSObject>

@optional
- (void)amrRecorder:(QLAMRRecorder *)amrRecorder DidFinishRecordWithFilePath:(NSString *)strAMRFilePath;
- (void)amrRecorder:(QLAMRRecorder *)amrRecorder FailedWithError:(NSError *)error;
- (void)amrRecorderDidCancel:(QLAMRRecorder *)amrRecorder;
- (void)amrRecorder:(QLAMRRecorder *)amrRecorder recordTime:(NSTimeInterval)recordTime volume:(Float32)volume;

@end
