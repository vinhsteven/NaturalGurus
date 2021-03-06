//
//  PaymentViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 7/8/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentViewController : UIViewController <UIScrollViewDelegate>{
    CGSize screenSize;
    
    NSMutableArray *monthArray;
    NSMutableArray *yearArray;
    int currentMonthIndex;
    int currentYearIndex;
}

@property (assign, readwrite) BOOL isBookLive;
@property (strong, nonatomic) IBOutlet UITextField *txtNameOnCard;
@property (strong, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (strong, nonatomic) IBOutlet UIButton *btnExpiredMonth;
@property (strong, nonatomic) IBOutlet UIButton *btnExpiredYear;
@property (strong, nonatomic) IBOutlet UITextField *txtCVV;
@property (strong, nonatomic) IBOutlet UILabel *lbExpertName;
@property (strong, nonatomic) IBOutlet UILabel *lbTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lbDuration;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbTime;
@property (strong, nonatomic) IBOutlet UIButton *btnConfirm;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) NSMutableDictionary *scheduleDict;

@property (strong, nonatomic) STPCard* stripeCard;

- (IBAction) selectMonth:(id)sender;
- (IBAction) selectYear:(id)sender;
- (IBAction) confirmAppointment:(id)sender;

- (void) bookingSuccess:(long)orderId;

@end
