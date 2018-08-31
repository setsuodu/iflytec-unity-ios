//
//  TTSConfig.m
//  MSCDemo_UI
//
//  Created by wangdan on 15-4-25.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import "TTSConfig.h"
#import "TTSUIController.h"

@implementation TTSConfig

-(id)init {
    self  = [super init];
    if (self) {
        [self defaultSetting];
        return  self;
    }
    return nil;
}

+(TTSConfig *)sharedInstance {
    static TTSConfig  * instance = nil;
    static dispatch_once_t predict;
    dispatch_once(&predict, ^{
        instance = [[TTSConfig alloc] init];
    });
    return instance;
}

-(void)defaultSetting {
    _speed = @"50";
    _volume = @"50";
    _pitch = @"50";
    _sampleRate = @"16000";
    _engineType = @"cloud";
    _vcnName = self.vcnName; //nannan
    NSLog(@"当前发音人 >> %@", _vcnName);

    _vcnNickNameArray = @[NSLocalizedString(@"xiaoyan", nil),
                          NSLocalizedString(@"xiaoyu", nil),
                          NSLocalizedString(@"xiaoyan2", nil),
                          NSLocalizedString(@"xiaoqi", nil),
                          NSLocalizedString(@"xiaofeng", nil),
                          NSLocalizedString(@"xiaoxin", nil),
                          NSLocalizedString(@"xiaokun", nil),
                          NSLocalizedString(@"English", nil),
                          NSLocalizedString(@"Vietnamese", nil),
                          NSLocalizedString(@"Hindi", nil),
                          NSLocalizedString(@"Spanish", nil),
                          NSLocalizedString(@"Russian", nil),
                          NSLocalizedString(@"French", nil)];
    
    _vcnIdentiferArray = @[@"xiaoyan",@"xiaoyu",@"vixy",@"vixq",@"vixf",@"vixx",@"vixk",@"catherine",@"XiaoYun",@"Abha",@"Gabriela",@"Allabent",@"Mariane"];
}

@end


#ifdef __cplusplus
extern "C" {
#endif
    
    void selectVoicer(const char *name)
    {
        NSString *_name = [NSString stringWithUTF8String:name];
        NSLog(@"选择 >> %@", _name);
        [TTSConfig sharedInstance].vcnName = _name;
        [[TTSUIController sharedInstance] initSynthesizer];
    }
    
#ifdef __cplusplus
}
#endif
