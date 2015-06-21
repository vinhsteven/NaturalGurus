//
//  ScheduleAppointmentViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/15/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleAppointmentViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate> {
    SZTextView *txtMessage;
    UITextField *txtFirstName;
    UITextField *txtLastName;
    UITextField *txtEmail;
    UIButton *btnDuration;
    UIButton *btnTimeZone;
    
    NSMutableArray *mainArray;
    
    CGSize screenSize;
    
    NSMutableArray *durationArray;
    NSMutableArray *timezoneArray;
    
    int currentPickerSelected;
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *mainTableView;

@end
