//
//  ISRConfigViewController.m
//  MSCDemo_UI
//
//  Created by wangdan on 15-4-25.
//  Copyright (c) 2015年 iflytek. All rights reserved.
//

#import "IATConfigViewController.h"
#import "IATConfig.h"
#import "Definition.h"

@interface IATConfigVIewController ()
@end

@implementation IATConfigVIewController

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 set recognition view
 */
- (IBAction)viewSegHandler:(id)sender {
    UISegmentedControl *control = sender;
    if (control.selectedSegmentIndex == 0) {
        [IATConfig sharedInstance].haveView = NO;
        
    }else if (control.selectedSegmentIndex == 1) {
        [IATConfig sharedInstance].haveView = YES;
    }
}

/*
 set punctuation
 */
- (IBAction)dotSegHandler:(id)sender {
    UISegmentedControl *control = sender;
    
    if (control.selectedSegmentIndex == 0) {
        [IATConfig sharedInstance].dot = [IFlySpeechConstant ASR_PTT_HAVEDOT];
        
    }else if (control.selectedSegmentIndex == 1) {
        [IATConfig sharedInstance].dot = [IFlySpeechConstant ASR_PTT_NODOT];
    }
}

/*
 set whether or not to open translation
 */
- (IBAction)translateSegHandler:(id)sender {
    UISegmentedControl *control = sender;
    
    if (control.selectedSegmentIndex == 0) {
        [IATConfig sharedInstance].isTranslate = YES;
    }else if (control.selectedSegmentIndex == 1) {
        [IATConfig sharedInstance].isTranslate = NO;
    }
}


@end
