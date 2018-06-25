//
//  TTSUIController.h
//  MSCDemo_UI
//
//  Created by wangdan on 15-4-25.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "IFlyMSC/IFlyMSC.h"
#import "UnityAppController.h"

@class IFlySpeechSynthesizer;

typedef NS_OPTIONS(NSInteger, SynthesizeType) {
    NomalType           = 5,    //Normal TTS
    UriType             = 6,    //URI TTS
};

//state of TTS
typedef NS_OPTIONS(NSInteger, Status) {
    NotStart            = 0,
    Playing             = 2,
    Paused              = 4,
};

/*
 demo of Text-to-Speech (TTS)
 
 Text-to-Speech has two work modes:
 1.Normal TTS: Playing While synthesizing;
 2.URI TTS   : Not Playing While synthesizing;
 */
@interface TTSUIController : UIViewController <IFlySpeechSynthesizerDelegate>
//@interface TTSUIController : UnityAppController <IFlySpeechSynthesizerDelegate>

@property (nonatomic, strong) IFlySpeechSynthesizer * iFlySpeechSynthesizer;

@property (nonatomic, assign) BOOL isCanceled;
@property (nonatomic, assign) BOOL hasError;
@property (nonatomic, assign) BOOL isViewDidDisappear;

@property (nonatomic, assign) Status state;
@property (nonatomic, assign) SynthesizeType synType;

+(TTSUIController *)sharedInstance;

-(void)initSynthesizer;

@end
