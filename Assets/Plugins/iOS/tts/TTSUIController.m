//
//  TTSUIController.m
//  MSCDemo_UI
//
//  Created by wangdan on 15-4-25.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import "TTSUIController.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVAudioSession.h>
#import <AudioToolbox/AudioSession.h>
#import "Definition.h"
#import "TTSConfig.h"

@implementation TTSUIController

+(TTSUIController *)sharedInstance {
    static TTSUIController  * instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[TTSUIController alloc] init];
    });
    return instance;
}

- (void)startSyn : (const char*)content{
    
    NSLog(@"==>> startSyn");
    
    _synType = NomalType;
    
    self.hasError = NO;
    [NSThread sleepForTimeInterval:0.05];
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //NSString* str= @"合成支持在线和离线两种工作方式，默认使用在线方式。";
    NSString* str = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
    
    [_iFlySpeechSynthesizer startSpeaking:str];
    if (_iFlySpeechSynthesizer.isSpeaking) {
        
        NSLog(@"==>> Playing");
        
        _state = Playing;
    }
}

// 初始化 TTS+ISR
- (void)initSynthesizer
{
    //Set APPID
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    [IFlySpeechUtility createUtility:initString];
    
    // 启用配置，语音语速发音人
    TTSConfig *instance = [TTSConfig sharedInstance];
    if (instance == nil) {
        return;
    }
    
    //TTS singleton
    if (_iFlySpeechSynthesizer == nil) {
        _iFlySpeechSynthesizer = [IFlySpeechSynthesizer sharedInstance];
    }
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //set speed,range from 1 to 100.
    [_iFlySpeechSynthesizer setParameter:instance.speed forKey:[IFlySpeechConstant SPEED]];
    
    //set volume,range from 1 to 100.
    [_iFlySpeechSynthesizer setParameter:instance.volume forKey:[IFlySpeechConstant VOLUME]];
    
    //set pitch,range from 1 to 100.
    [_iFlySpeechSynthesizer setParameter:instance.pitch forKey:[IFlySpeechConstant PITCH]];
    
    //set sample rate
    [_iFlySpeechSynthesizer setParameter:instance.sampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
    
    //set TTS speaker
    [_iFlySpeechSynthesizer setParameter:instance.vcnName forKey:[IFlySpeechConstant VOICE_NAME]];
    
    //set text encoding mode
    [_iFlySpeechSynthesizer setParameter:@"unicode" forKey:[IFlySpeechConstant TEXT_ENCODING]];
    
    //set engine type
    [_iFlySpeechSynthesizer setParameter:instance.engineType forKey:[IFlySpeechConstant ENGINE_TYPE]];
}

#pragma mark - IFlySpeechSynthesizerDelegate

/**
 callback of starting playing
 Notice：
 Only apply to normal TTS
 **/
- (void)onSpeakBegin
{
    self.isCanceled = NO;
    _state = Playing;
}

/**
 callback of buffer progress
 Notice：
 Only apply to normal TTS
 **/
- (void)onBufferProgress:(int) progress message:(NSString *)msg
{
    NSLog(@"buffer progress %2d%%. msg: %@.", progress, msg);
}

/**
 callback of playback progress
 Notice：
 Only apply to normal TTS
 **/
- (void) onSpeakProgress:(int) progress beginPos:(int)beginPos endPos:(int)endPos
{
    // 朗读过程，已读全文百分比
    NSLog(@"speak progress %2d%%, beginPos=%d, endPos=%d", progress,beginPos,endPos);
}

/**
 callback of pausing player
 Notice：
 Only apply to normal TTS
 **/
- (void)onSpeakPaused
{
    // 当暂停时
    NSLog(@"==>> 暂停了");
    _state = Paused;
}

- (void)onCompleted:(IFlySpeechError *)error {
    // 当全部内容读完
    NSLog(@"%s,error=%d",__func__,error.errorCode);
    
    _state = NotStart;
}

@end

#ifdef __cplusplus
extern "C" {
#endif
    
    TTSUIController * controller;
    
    void initSynthesizer()
    {
        NSLog(@"==>> 初始化");
        
        controller = [TTSUIController sharedInstance];
        [controller initSynthesizer];
    }
    
    void startTTS(const char * content)
    {
        NSString* str = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
        NSLog(@"Unity参数 ==>> @%@", str);
        
        // 实例化，直接运行.m中的函数
        [controller startSyn:content];
    }
    
    void pauseTTS()
    {
        NSLog(@"==>> 暂停");
        [controller.iFlySpeechSynthesizer pauseSpeaking];
    }
    
    void resumeTTS()
    {
        NSLog(@"==>> 恢复");
        [controller.iFlySpeechSynthesizer resumeSpeaking];
    }
    
    void stopTTS()
    {
        NSLog(@"==>> 结束");
        [controller.iFlySpeechSynthesizer stopSpeaking];
    }
    
#ifdef __cplusplus
}
#endif
