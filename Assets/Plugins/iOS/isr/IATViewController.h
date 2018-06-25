//
//  IATViewController.h
//  MSCDemo_UI
//
//  Created by wangdan on 15-4-28.
//
//

#import "IFlyMSC/IFlyMSC.h"

//forward declare
@class IFlyDataUploader;
@class IFlySpeechRecognizer;
@class IFlyPcmRecorder;

/**
 demo of Short Form ASR (IAT)

 Four steps to integrating Short Form ASR as follows:
 1.Instantiate IFlySpeechRecognizer singleton;
 2.Set recognition params;
 3.Add IFlySpeechRecognizerDelegate or IFlyRecognizerViewDelegate methods selectively;
 4.Start recognition;
 */
@interface IATViewController : UIViewController<IFlySpeechRecognizerDelegate,IFlyRecognizerViewDelegate,UIActionSheetDelegate,IFlyPcmRecorderDelegate>

@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//Recognition conrol without view
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//Recognition control with view
@property (nonatomic, strong) IFlyDataUploader *uploader;//upload control

@property (nonatomic, strong) NSString * result;
@property (nonatomic, assign) BOOL isCanceled;

@property (nonatomic,strong) IFlyPcmRecorder *pcmRecorder;//PCM Recorder to be used to demonstrate Audio Stream Recognition.
@property (nonatomic,assign) BOOL isStreamRec;//Whether or not it is Audio Stream function
@property (nonatomic,assign) BOOL isBeginOfSpeech;//Whether or not SDK has invoke the delegate methods of beginOfSpeech.


@end
