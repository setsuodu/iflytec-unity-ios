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

/**
 start normal TTS
 **/
- (void)startSyn:(const char*)content{
    
    _synType = NomalType;
    
    self.hasError = NO;
    
    [NSThread sleepForTimeInterval:0.05];
    
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    
    //NSString* text= @"合成支持在线和离线两种工作方式，默认使用在线方式。";
    NSString* text = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
    
    [_iFlySpeechSynthesizer startSpeaking:text]; //合成并播放
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}


/**
 start URI TTS
 **/
- (void)uriSynthesize:(const char*)content Uri:(const char*)path{
    
    _synType = UriType;
    
    self.hasError = NO;
    
    [NSThread sleepForTimeInterval:0.05];
    
    self.isCanceled = NO;
    
    _iFlySpeechSynthesizer.delegate = self;
    
    NSString* _text = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
    _wavPath = [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
    NSLog(@"uri ==>> %@", _wavPath);
    
    [_iFlySpeechSynthesizer synthesize:_text toUri:_uriPath]; //合成uri.pcm，不播放
    if (_iFlySpeechSynthesizer.isSpeaking) {
        _state = Playing;
    }
}

// 初始化 TTS+ISR
- (void)initSynthesizer
{
    NSString *prePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //Set the audio file name for URI TTS
    _uriPath = [NSString stringWithFormat:@"%@/%@",prePath,@"uri.pcm"];
    //Instantiate player for URI TTS
    //_audioPlayer = [[PcmPlayer alloc] init];
    
    
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
    
    //URI TTS
    if (_synType == UriType) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:_uriPath]) {
            NSLog(@"uriPath exsit");
        }
        else {
            NSLog(@"uriPath not exsit");
        }
        
        if ([fm fileExistsAtPath:_wavPath]) {
            NSLog(@"before mp3Path exsit");
        }
        else {
            NSLog(@"before mp3Path not exsit");
        }
        
        // 转码
        [self getAndCreatePlayableFileFromPcmData];
        
        NSLog(@"转码成功，播放...");
        
        if (_synType == UriType) {
            NSFileManager *fm = [NSFileManager defaultManager];
            if ([fm fileExistsAtPath:_wavPath]) {
                NSLog(@"after wavPath exsit");
            }
            else {
                NSLog(@"after wavPath not exsit");
            }
            
            // 回调
            NSString* nsLog = @"pcm->mp3转码完成";
            const char* charLog = [nsLog UTF8String];
            UnitySendMessage("Main Camera", "OnComplete", charLog);
        }
    }
    
    _state = NotStart;
}

- (NSURL *) getAndCreatePlayableFileFromPcmData
{
    NSString *wavFilePath = _wavPath;  //wav文件的路径
    NSLog(@"PCM file path : %@",_uriPath); //pcm文件的路径
    
    FILE *fout;
    
    short NumChannels = 1;       //录音通道数
    short BitsPerSample = 32;    //线性采样位数
    int SamplingRate = 8000;     //录音采样率(Hz)
    int numOfSamples = (int)[[NSData dataWithContentsOfFile:_uriPath] length];
    
    int ByteRate = NumChannels*BitsPerSample*SamplingRate/8;
    short BlockAlign = NumChannels*BitsPerSample/8;
    int DataSize = NumChannels*numOfSamples*BitsPerSample/8;
    int chunkSize = 16;
    int totalSize = 46 + DataSize;
    short audioFormat = 1;
    
    if((fout = fopen([wavFilePath cStringUsingEncoding:1], "w")) == NULL)
    {
        printf("Error opening out file ");
    }
    
    fwrite("RIFF", sizeof(char), 4,fout);
    fwrite(&totalSize, sizeof(int), 1, fout);
    fwrite("WAVE", sizeof(char), 4, fout);
    fwrite("fmt ", sizeof(char), 4, fout);
    fwrite(&chunkSize, sizeof(int),1,fout);
    fwrite(&audioFormat, sizeof(short), 1, fout);
    fwrite(&NumChannels, sizeof(short),1,fout);
    fwrite(&SamplingRate, sizeof(int), 1, fout);
    fwrite(&ByteRate, sizeof(int), 1, fout);
    fwrite(&BlockAlign, sizeof(short), 1, fout);
    fwrite(&BitsPerSample, sizeof(short), 1, fout);
    fwrite("data", sizeof(char), 4, fout);
    fwrite(&DataSize, sizeof(int), 1, fout);
    
    fclose(fout);
    
    NSMutableData *pamdata = [NSMutableData dataWithContentsOfFile:_uriPath];
    NSFileHandle *handle;
    handle = [NSFileHandle fileHandleForUpdatingAtPath:wavFilePath];
    [handle seekToEndOfFile];
    [handle writeData:pamdata];
    [handle closeFile];
    
    return [NSURL URLWithString:wavFilePath];
}


@end

#ifdef __cplusplus
extern "C" {
#endif
    
    void initSynthesizer()
    {
        NSLog(@"==>> 初始化");
        [[TTSUIController sharedInstance] initSynthesizer]; //语速、音量、发音人等配置
    }
    
    void startTTS(const char* content)
    {
        NSString* _content = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
        NSLog(@"Unity参数 ==>> @%@", _content);
        // 实例化，直接运行.m中的函数
        [[TTSUIController sharedInstance] startSyn:content];
    }
    
    void startUriTTS(const char* content, const char* path)
    {
        NSString* _content = [NSString stringWithCString:content encoding:NSUTF8StringEncoding];
        NSString* _path = [NSString stringWithCString:path encoding:NSUTF8StringEncoding];
        NSLog(@"Unity参数 ==>> @%@, %@", _content, _path);
        [[TTSUIController sharedInstance] uriSynthesize:content Uri:path];
    }
    
    void pauseTTS()
    {
        NSLog(@"==>> 暂停");
        [[TTSUIController sharedInstance].iFlySpeechSynthesizer pauseSpeaking];
    }
    
    void resumeTTS()
    {
        NSLog(@"==>> 恢复");
        [[TTSUIController sharedInstance].iFlySpeechSynthesizer resumeSpeaking];
    }
    
    void stopTTS()
    {
        NSLog(@"==>> 结束");
        [[TTSUIController sharedInstance].iFlySpeechSynthesizer stopSpeaking];
    }
    
    
#ifdef __cplusplus
}
#endif
