//
//  BookLiveViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 7/17/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BookLiveViewController : UIViewController {
    int countDown;
    NSTimer *timer;
}

@property (assign,readwrite) BOOL isOpening; //to prevent present when it's opening
@property (strong,nonatomic) IBOutlet UILabel *lbTitle;
@property (strong,nonatomic) IBOutlet UITextView *txtMessage;
@property (strong,nonatomic) NSMutableDictionary *scheduleDict;
@property (strong,nonatomic) IBOutlet UIActivityIndicatorView *myIndicatorView;

+ (BookLiveViewController *) instance;

- (void) hideCloseButton;

- (void) reloadInput;
- (void) expertDecline;
- (void) expertAccept;
- (void) expertWaitingProcessPayment;
- (void) handleAfterPaymentSuccess:(long)orderId;

@end
