//
//  ScheduleAppointmentViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/15/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "ScheduleAppointmentViewController.h"
#import "AvailabilityViewController.h"
#import "PaymentViewController.h"
#import "ConfirmedViewController.h"

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
@synthesize durationArray;

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
    [self.btnViewAvailability setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnViewAvailability setTitle:@"View Availability" forState:UIControlStateNormal];
    [self.btnViewAvailability setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    
    //add next button to transfer to payment screen
    UIBarButtonItem *btnNext = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(transferPaymentForm)];
    self.navigationItem.rightBarButtonItem = btnNext;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    //init data for timezone array
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"TimeZone" ofType:@"plist"];
    timezoneArray = [NSMutableArray arrayWithContentsOfFile:filePath];
    
    //alloc schedule dict to save temporary data for booking
    self.scheduleDict = [[NSMutableDictionary alloc] init];
    self.timeDict = [[NSMutableDictionary alloc] init];
    
    //check if free session, dont show select duration and total
    if (self.isFreeSession) {
        self.lbLengthOfSession.hidden = self.btnDuration.hidden = self.lbTotalTitle.hidden = self.lbTotal.hidden = YES;
        [self.btnViewAvailability setBackgroundImage:[ToolClass imageFromColor:ORANGE_COLOR] forState:UIControlStateNormal];
    }
    
    self.txtFirstName.text = [[ToolClass instance] getUserFirstName];
    self.txtLastName.text  = [[ToolClass instance] getUserLastName];
    self.txtEmail.text     = [[ToolClass instance] getUserEmail];
    
    NSDictionary *expertDict = [[ToolClass instance] getExpertDict];
    self.lbMessageTo.text = [NSString stringWithFormat:@"Message to %@:",[expertDict objectForKey:@"name"]];
    
    //get current timezone of device
    NSTimeZone *deviceTimezone = [NSTimeZone localTimeZone];
    
    for (int i=0;i < [timezoneArray count];i++) {
        NSDictionary *timezoneDict = [timezoneArray objectAtIndex:i];
        NSTimeZone *timezone = [NSTimeZone timeZoneWithName:[timezoneDict objectForKey:@"value"]];
        
        NSInteger deviceIntervalTime = [deviceTimezone secondsFromGMT] - [deviceTimezone daylightSavingTimeOffset];
        NSInteger intervalTime = [timezone secondsFromGMT] - [timezone daylightSavingTimeOffset];
        
        if (deviceIntervalTime == intervalTime) {
            //get interval time from device timezone to GMT
            if ([deviceTimezone isEqualToTimeZone:timezone]) {
                currentTimezoneSelectedDict = timezoneDict;
            }
            else {
                
                int hour = (int)deviceIntervalTime/3600;
                int min  = (deviceIntervalTime % 3600) / 60;
                
                NSString *timezoneName = [deviceTimezone name];
                
                NSArray *tmpArray = [timezoneName componentsSeparatedByString:@"/"];
                NSEnumerator *nse = [tmpArray objectEnumerator];
                
                [nse nextObject]; // don't remove this line, omit zone 
                NSString *city = [nse nextObject];
                city = [city stringByReplacingOccurrencesOfString:@"_" withString:@" "];
                
                NSString *sign = @"";
                if (hour > 0)
                    sign = @"+";
                
                NSString *timezoneTitle = [NSString stringWithFormat:@"UTC(%@%02d:%02d) %@",sign,hour,min,city];
                
                currentTimezoneSelectedDict = [NSDictionary dictionaryWithObjectsAndKeys:timezoneTitle,@"title",timezoneName,@"value", nil];
                [timezoneArray insertObject:currentTimezoneSelectedDict atIndex:i];
            }
            break;
        }
    }
    
//    currentTimezoneSelectedDict = [NSDictionary dictionaryWithObjectsAndKeys:@"(UTC+10:00) Sydney",@"title",@"Australia/Sydney",@"value", nil];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Schedule";
}

- (void) viewDidLayoutSubviews {
    if (screenSize.height == 568) {
        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height+100)];
    }
    else if (screenSize.height == 480) {
        [self.mainScrollView setContentSize:CGSizeMake(self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height+200)];
    }
    
    if (self.isBookLive) {
        self.btnViewAvailability.hidden = YES;
        self.mainScrollView.frame = CGRectMake(self.mainScrollView.frame.origin.x, self.mainScrollView.frame.origin.y, self.mainScrollView.frame.size.width, screenSize.height-84);
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
                           withObjects:durationArray
                           withOptions:nil
                            completion:^(NSInteger selectedIndex) {
                                //return selected index
                                currentDurationSelected = (int)selectedIndex;
                                
                                NSDictionary *dict = [durationArray objectAtIndex:currentDurationSelected];
                                [self.btnDuration setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
                                
                                float value = [[dict objectForKey:@"value"] floatValue];
                                float price = [[ToolClass instance] getExpertPrice];
                                float total = price * value;
                                self.lbTotal.text = [NSString stringWithFormat:@"$%.2f",total];
                                
                                [self.scheduleDict setObject:[NSNumber numberWithFloat:value] forKey:@"duration"];
                                [self.scheduleDict setObject:[NSNumber numberWithFloat:total] forKey:@"total"];
                                
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
                           withObjects:timezoneArray
                           withOptions:currentTimezoneSelectedDict
                            completion:^(NSInteger selectedIndex) {
                                //return selected index
                                currentTimeZoneSelected = (int)selectedIndex;
                                
                                currentTimezoneSelectedDict = [timezoneArray objectAtIndex:currentTimeZoneSelected];
                                [self.btnTimeZone setTitle:[currentTimezoneSelectedDict objectForKey:@"title"] forState:UIControlStateNormal];
                                
                                NSString *value = [currentTimezoneSelectedDict objectForKey:@"value"];
                                [self.scheduleDict setObject:value forKey:@"timezone"];
                            }];
}

- (IBAction) handleViewAvailability:(id)sender {
    self.navigationItem.title = @"";
    
    if ([self.btnTimeZone.titleLabel.text isEqualToString:@"Select time zone"]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select your time zone before proceeding the availabilities" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if (!self.isFreeSession) {
        if ([self.btnDuration.titleLabel.text isEqualToString:@"Select duration"]) {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select your the duration before proceeding the availabilities" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
            return;
        }
    }
    
    NSDictionary *timezoneDict = [timezoneArray objectAtIndex:currentTimeZoneSelected];
    NSDictionary *durationDict = [durationArray objectAtIndex:currentDurationSelected];
    
    AvailabilityViewController *controller = [[AvailabilityViewController alloc] initWithNibName:@"AvailabilityViewController" bundle:nil];
    controller.parent = self;
    controller.isFree = self.isFreeSession;
    
    if (!self.isFreeSession)
        controller.duration = [[durationDict objectForKey:@"value"] intValue];
    else {
        controller.duration = self.freeSessionDuration;
    }
    controller.timezoneValueString = [timezoneDict objectForKey:@"value"];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) handleSingleTap:(UITapGestureRecognizer*)tap {
    [self.txtMessage resignFirstResponder];
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
}

- (void) transferPaymentForm {
    if ([self.txtMessage.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your message" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if (self.txtMessage.text.length < 10) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"The content must be at least 10 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if ([self.txtFirstName.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your first name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if ([self.txtLastName.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if ([self.txtEmail.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if ([self.btnTimeZone.titleLabel.text isEqualToString:@"Select time zone"]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select your time zone before proceeding the payment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    if (!self.isFreeSession) {
        if ([self.btnDuration.titleLabel.text isEqualToString:@"Select duration"]) {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select your the duration before proceeding the payment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
            return;
        }
    }
    if (!self.isBookLive) {
        if (self.timeDict == nil || [[self.timeDict allKeys] count] == 0) {
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select available time before proceeding the payment" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
            return;
        }
    }
    
    float total = [[self.scheduleDict objectForKey:@"total"] floatValue];
    //Stripe just accept a transaction with greater than $0.5
    if (total < 0.5 && !self.isFreeSession) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"We can't process payment with less than $0.5. Please choose more." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    [self.scheduleDict setObject:self.txtMessage.text forKey:@"message"];
    [self.scheduleDict setObject:self.txtEmail.text forKey:@"email"];
    [self.scheduleDict setObject:self.txtFirstName.text forKey:@"firstname"];
    [self.scheduleDict setObject:self.txtLastName.text forKey:@"lastname"];
    
    NSDictionary *expertDict = [[ToolClass instance] getExpertDict];
    [self.scheduleDict setObject:[expertDict objectForKey:@"name"] forKey:@"expertName"];
    [self.scheduleDict setObject:[expertDict objectForKey:@"id"] forKey:@"expertId"];
    
    if (self.isBookLive) {
        //if Book Live, we dont need to choose availability, just get current device time and device timezone
        
        NSDate *currentDate  = [NSDate date];
        NSTimeZone *timezone = [NSTimeZone systemTimeZone];
        
        NSString *currentDateStr = [ToolClass dateTimeByTimezone:timezone.name andDate2:currentDate];
        
        int duration = [[self.scheduleDict objectForKey:@"duration"] intValue];
        
        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
        dayComponent.day = 0;
        dayComponent.minute = 5;
        
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        
        NSDate *fromDate = [theCalendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
        NSString *fromDateStr = [ToolClass dateTimeByTimezone:timezone.name andDate2:fromDate];
        
        dayComponent.minute = duration;
        NSDate *toDate = [theCalendar dateByAddingComponents:dayComponent toDate:fromDate options:0];
        NSString *toDateStr = [ToolClass dateTimeByTimezone:timezone.name andDate2:toDate];
        
        NSString *fromDateOnly = [ToolClass dateByTimezone:timezone.name andDate:fromDateStr];
        NSString *toDateOnly   = [ToolClass dateByTimezone:timezone.name andDate:toDateStr];
        
        NSString *fromTimeOnly = [ToolClass timeByTimezone:timezone.name andDateAndTime:fromDateStr];
        NSString *toTimeOnly   = [ToolClass timeByTimezone:timezone.name andDateAndTime:toDateStr];
        
        NSString *title = [NSString stringWithFormat:@"%@ - %@",[ToolClass convertHourToAM_PM:fromTimeOnly],[ToolClass convertHourToAM_PM:toTimeOnly]];
        
        [self.timeDict setValue:fromDateOnly forKey:@"date_from"];
        [self.timeDict setValue:toDateOnly forKey:@"date_to"];
        [self.timeDict setValue:[NSNumber numberWithInt:0] forKey:@"free"];
        [self.timeDict setValue:fromTimeOnly forKey:@"from_time"];
        [self.timeDict setValue:toTimeOnly forKey:@"to_time"];
        [self.timeDict setValue:title forKey:@"title"];
        
        [self.scheduleDict setObject:self.timeDict forKey:@"timeDict"];
        
        //call API to send push notification to expert
        NSString *token = [[ToolClass instance] getUserToken];
        
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",[self.scheduleDict objectForKey:@"expertId"],@"expert_id",[self.scheduleDict objectForKey:@"message"],@"about",[NSNumber numberWithInt:duration],@"duration",[self.scheduleDict objectForKey:@"total"],@"total", nil];
        [[ToolClass instance] sendLiveRequest:params viewController:self];
    }
    else {
        [self.scheduleDict setObject:self.timeDict forKey:@"timeDict"];
        
        self.navigationItem.title = @"";
        
        if (!self.isFreeSession) {
            PaymentViewController *controller = [[PaymentViewController alloc] initWithNibName:@"PaymentViewController" bundle:nil];
            controller.scheduleDict = self.scheduleDict;
            [self.navigationController pushViewController:controller animated:YES];
        }
        else {
            //book appointment without payment
            [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[self.scheduleDict objectForKey:@"message"],@"about",[self.scheduleDict objectForKey:@"expertId"],@"expert_id",[NSNumber numberWithInt:self.freeSessionDuration],@"duration",[self.timeDict objectForKey:@"timezone"],@"client_timezone",[NSNumber numberWithFloat:0],@"total",[self.timeDict objectForKey:@"date_from"],@"date",[self.timeDict objectForKey:@"from_time"],@"from_time",[self.timeDict objectForKey:@"to_time"],@"to_time",@"iOS",@"booked_from",[[ToolClass instance] getUserToken],@"token",[NSNumber numberWithInt:self.isFreeSession],@"free",@"",@"stripe_token", nil];
            
            [[ToolClass instance] bookSchedule:params withViewController:self];
        }
    }
}

- (void) bookingSuccess {
    ConfirmedViewController *controller = [[ConfirmedViewController alloc] initWithNibName:@"ConfirmedViewController" bundle:nil];
    controller.isFreeSession = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void) sendLiveRequestSuccessful:(NSDictionary*)request {
    if (![BookLiveViewController instance].isOpening) {
        UINavigationController *tmpNavController = [[UINavigationController alloc] initWithRootViewController:[BookLiveViewController instance]];
        [self.navigationController presentViewController:tmpNavController animated:YES completion:nil];
    }
    [[BookLiveViewController instance] reloadInput];
    [self.scheduleDict setValue:[request objectForKey:@"id"] forKey:@"live_request_id"];
    [[BookLiveViewController instance] setScheduleDict:self.scheduleDict];
}

#pragma mark UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    CGRect rect = [textField bounds];
    rect = [textField convertRect:rect toView:self.mainScrollView];
    rect.origin.x = 0 ;
    rect.origin.y -= 60 ;
    rect.size.height = 400;
    
    [self.mainScrollView scrollRectToVisible:rect animated:YES];
}

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
