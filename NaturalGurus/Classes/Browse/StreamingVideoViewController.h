//
//  ViewController.h
//  Hello-World
//
//  Copyright (c) 2013 TokBox, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define OPENTOK_API_KEY     @"45275422"
#define OPENTOK_API_SECRET  @"4378fd4f758fd51689737f04999dd86b28faf98a"

@interface StreamingVideoViewController : UIViewController {
    CGSize screenSize;
    UIButton *btnEndCall;
    UIButton *btnClose;
    
    UILabel *lbTimer;
    NSTimer *timer;
}

@property (assign, readwrite) NSString *kApiKey;
@property (assign, readwrite) NSString *kSessionId;
@property (assign, readwrite) NSString *kToken;

@property (unsafe_unretained) id parent;
@property (assign,readwrite) int duration;
@property (assign,readwrite) int actualDuration;
@property (assign,readwrite) long appointmentId;

- (void) finishAppointment;

@end
