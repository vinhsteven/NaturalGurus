//
//  ScheduleAppointmentViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/15/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleAppointmentViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate> {
    
    NSMutableArray *mainArray;
    
    CGSize screenSize;
    
    NSMutableArray *durationArray;
    NSMutableArray *timezoneArray;
    
    int currentPickerSelected;
}

@property (strong, nonatomic) IBOutlet UILabel *lbMessageTo;
@property (strong, nonatomic) IBOutlet UILabel *lbYourDetails;
@property (strong, nonatomic) IBOutlet UILabel *lbYourTimezone;
@property (strong, nonatomic) IBOutlet UILabel *lbLengthOfSession;
@property (strong, nonatomic) IBOutlet SZTextView *txtMessage;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnDuration;
@property (strong, nonatomic) IBOutlet UIButton *btnTimeZone;
@property (strong, nonatomic) IBOutlet UILabel *lbTotal;
@property (strong, nonatomic) IBOutlet UIButton *btnViewAvailability;

- (IBAction) hanldeChangeDuration:(id)sender;
- (IBAction) handleChangeTimezone:(id)sender;
- (IBAction) handleViewAvailability:(id)sender;

@end
