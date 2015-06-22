//
//  ScheduleAppointmentViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/15/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "ScheduleAppointmentViewController.h"

enum {
    kMessageSection,
    kDetailSection,
    kLengthOfSessionSection,
    kTimezoneSection
};

enum {
    kCurrentDurationPicker = 1,
    kCurrentTimezonePicker
};

@implementation ScheduleAppointmentViewController

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.navigationItem.title = @"Schedule";
    
    //set corner radius for container view
    self.containerView.layer.cornerRadius  = 5;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.containerView.layer.borderWidth = 1;
    
    //allocate message text view
    self.txtMessage.layer.cornerRadius  = 5;
    self.txtMessage.layer.masksToBounds = YES;
    self.txtMessage.layer.borderWidth   = 1;
    self.txtMessage.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.txtMessage.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    self.txtMessage.placeholder = @"Type a personal message here about what you want to talk about...";
    self.txtMessage.returnKeyType = UIReturnKeyNext;
    
    //style for container view
    self.containerView.layer.cornerRadius  = 5;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderWidth   = 1;
    self.containerView.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    
    //allocate firstname, last name, email
    self.txtFirstName.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    self.txtFirstName.placeholder = @"First name";
    self.txtFirstName.borderStyle = UITextBorderStyleNone;
    self.txtFirstName.returnKeyType = UIReturnKeyNext;
    
    self.txtLastName.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    self.txtLastName.placeholder = @"Last name";
    self.txtLastName.borderStyle = UITextBorderStyleNone;
    self.txtLastName.returnKeyType = UIReturnKeyNext;
    
    self.txtEmail.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    self.txtEmail.placeholder = @"Email address";
    self.txtEmail.borderStyle = UITextBorderStyleNone;
    self.txtEmail.returnKeyType = UIReturnKeyDone;
    
    //allocate duration button
    self.btnDuration.layer.cornerRadius  = 5;
    self.btnDuration.layer.masksToBounds = YES;
    self.btnDuration.layer.borderWidth   = 1;
    self.btnDuration.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.btnDuration.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    [self.btnDuration setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [self.btnDuration setTitle:@"Select duration" forState:UIControlStateNormal];
    
    
    //allocate time zone
    self.btnTimeZone.layer.cornerRadius  = 5;
    self.btnTimeZone.layer.masksToBounds = YES;
    self.btnTimeZone.layer.borderWidth   = 1;
    self.btnTimeZone.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.btnTimeZone.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    [self.btnTimeZone setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [self.btnTimeZone setTitle:@"Select time zone" forState:UIControlStateNormal];
    
    //set style for availability button
    self.btnViewAvailability.layer.cornerRadius  = 5;
    self.btnViewAvailability.layer.masksToBounds = YES;
    self.btnViewAvailability.layer.borderWidth   = 1;
    self.btnViewAvailability.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.btnViewAvailability.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    [self.btnViewAvailability setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
    [self.btnViewAvailability setTitle:@"View Availability" forState:UIControlStateNormal];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    //init data for duration array
    NSString *durationValue[] = {
        @"15",
        @"30",
        @"45"
    };
    
    durationArray = [NSMutableArray arrayWithCapacity:1];
    for (int i=0;i < sizeof(durationValue)/sizeof(durationValue[0]);i++) {
        NSString *title = [NSString stringWithFormat:@"%@ minutes",durationValue[i]];
        [durationArray addObject:title];
    }
    
    //init data for timezone array
    NSString *timezoneTitle[] = {
        @"GMT (-12) Alaska",
        @"GMT (-11) Seattle",
        @"GMT (-10) Central America"
    };
    
    timezoneArray = [NSMutableArray arrayWithCapacity:1];
    for (int i=0;i < sizeof(timezoneTitle)/sizeof(timezoneTitle[0]);i++){
        [timezoneArray addObject:timezoneTitle[i]];
    }
}

- (IBAction) hanldeChangeDuration:(id)sender {
    //hide keyboard if it has already showed
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtMessage resignFirstResponder];
    
    currentPickerSelected = kCurrentDurationPicker;
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:durationArray
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                [self.btnDuration setTitle:selectedString forState:UIControlStateNormal];
                                self.btnDuration.titleLabel.text = selectedString;
                            }];
    
    
}

- (IBAction) handleChangeTimezone:(id)sender {
    //hide keyboard if it has already showed
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtMessage resignFirstResponder];
    
    currentPickerSelected = kCurrentTimezonePicker;
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:timezoneArray
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                [self.btnTimeZone setTitle:selectedString forState:UIControlStateNormal];
                                self.btnTimeZone.titleLabel.text = selectedString;
                            }];
}

- (IBAction) handleViewAvailability:(id)sender {
    
}

- (void) handleSingleTap:(UITapGestureRecognizer*)tap {
    [self.txtMessage resignFirstResponder];
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtFirstName) {
        [self.txtLastName becomeFirstResponder];
    }
    else if (textField == self.txtLastName) {
        [self.txtEmail becomeFirstResponder];
    }
    else if (textField == self.txtEmail) {
        [self.txtEmail resignFirstResponder];
    }
    return YES;
}

#pragma mark UITextViewDelegate
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    txtMessage.text = textView.text;
//    [txtFirstName becomeFirstResponder];
//}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self.txtFirstName becomeFirstResponder];
        return NO;
    }
    return YES;
}

@end
