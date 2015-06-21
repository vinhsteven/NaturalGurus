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
@synthesize mainTableView;

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
    
    //allocate message text view
    txtMessage = [[SZTextView alloc] initWithFrame:CGRectMake(5, 5, screenSize.width-5, 75)];
    txtMessage.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtMessage.placeholder = @"Type a personal message here about what you want to talk about...";
    txtMessage.returnKeyType = UIReturnKeyNext;
    txtMessage.delegate = self;
    
    //allocate firstname, last name, email
    txtFirstName = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 30)];
    txtFirstName.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtFirstName.placeholder = @"First name";
    txtFirstName.borderStyle = UITextBorderStyleNone;
    txtFirstName.returnKeyType = UIReturnKeyNext;
    txtFirstName.delegate = self;
    
    txtLastName = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 30)];
    txtLastName.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtLastName.placeholder = @"Last name";
    txtLastName.borderStyle = UITextBorderStyleNone;
    txtLastName.returnKeyType = UIReturnKeyNext;
    txtLastName.delegate = self;
    
    txtEmail = [[UITextField alloc] initWithFrame:CGRectMake(5, 0, screenSize.width-5, 30)];
    txtEmail.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    txtEmail.placeholder = @"Email address";
    txtEmail.borderStyle = UITextBorderStyleNone;
    txtEmail.returnKeyType = UIReturnKeyDone;
    txtEmail.delegate = self;
    
    //allocate duration button
    btnDuration = [UIButton buttonWithType:UIButtonTypeSystem];
    btnDuration.frame = CGRectMake(5, 0, screenSize.width-5, 30);
    btnDuration.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:13];
    btnDuration.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    btnDuration.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [btnDuration addTarget:self action:@selector(hanldeChangeDuration) forControlEvents:UIControlEventTouchUpInside];
    [btnDuration setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnDuration setTitle:@"Select duration" forState:UIControlStateNormal];
    
    
    //allocate time zone
    btnTimeZone = [UIButton buttonWithType:UIButtonTypeSystem];
    btnTimeZone.frame = CGRectMake(5, 0, screenSize.width-5, 30);
    btnTimeZone.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT size:13];
//    btnTimeZone.contentEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    btnTimeZone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [btnTimeZone addTarget:self action:@selector(handleChangeTimezone) forControlEvents:UIControlEventTouchUpInside];
    [btnTimeZone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnTimeZone setTitle:@"Select time zone" forState:UIControlStateNormal];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.mainTableView addGestureRecognizer:singleTap];
    
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

- (void) hanldeChangeDuration {
    //hide keyboard if it has already showed
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtMessage resignFirstResponder];
    
    currentPickerSelected = kCurrentDurationPicker;
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:durationArray
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                [btnDuration setTitle:selectedString forState:UIControlStateNormal];
                                btnDuration.titleLabel.text = selectedString;
                            }];
    
    
}

- (void) handleChangeTimezone {
    //hide keyboard if it has already showed
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmail resignFirstResponder];
    [txtMessage resignFirstResponder];
    
    currentPickerSelected = kCurrentTimezonePicker;
    
    [MMPickerView showPickerViewInView:self.view
                           withStrings:timezoneArray
                           withOptions:nil
                            completion:^(NSString *selectedString) {
                                //selectedString is the return value which you can use as you wish
                                [btnTimeZone setTitle:selectedString forState:UIControlStateNormal];
                                btnTimeZone.titleLabel.text = selectedString;
                            }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    
    switch (indexPath.section) {
        case kMessageSection:
            [cell.contentView addSubview:txtMessage];
            break;
        case kDetailSection:
            if (indexPath.row == 0)
                [cell.contentView addSubview:txtFirstName];
            else if (indexPath.row == 1)
                [cell.contentView addSubview:txtLastName];
            else
                [cell.contentView addSubview:txtEmail];
            break;
        case kLengthOfSessionSection:
            [cell.contentView addSubview:btnDuration];
            break;
        case kTimezoneSection:
            [cell.contentView addSubview:btnTimeZone];
            break;
        default:
            break;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numberRowsInSection = 0;
    switch (section) {
        case kMessageSection:
            numberRowsInSection = 1;
            break;
        case kDetailSection:
            numberRowsInSection = 3;
            break;
        case kLengthOfSessionSection:
            numberRowsInSection = 1;
            break;
        case kTimezoneSection:
            numberRowsInSection = 1;
            break;
        default:
            break;
    }
    return numberRowsInSection;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *headerTitle = @"";
    switch (section) {
        case kMessageSection:
        {
            NSString *expertName = @"Jackie Ward";
            headerTitle = [NSString stringWithFormat:@"Message to %@",expertName];
            break;
        }
        case kDetailSection:
            headerTitle = @"Your details";
            break;
        case kLengthOfSessionSection:
            headerTitle = @"Length of session";
            break;
        case kTimezoneSection:
            headerTitle = @"Your time zone";
            break;
        default:
            break;
    }
    return headerTitle;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int height;
    switch (indexPath.section) {
        case kMessageSection:
            height = 80;
            break;
        default:
            height = 30;
            break;
    }
    return height;
}

- (void) handleSingleTap:(UITapGestureRecognizer*)tap {
    [txtMessage resignFirstResponder];
    [txtFirstName resignFirstResponder];
    [txtLastName resignFirstResponder];
    [txtEmail resignFirstResponder];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == txtFirstName) {
        [txtLastName becomeFirstResponder];
    }
    else if (textField == txtLastName) {
        [txtEmail becomeFirstResponder];
    }
    else if (textField == txtEmail) {
        [txtEmail resignFirstResponder];
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
        [txtFirstName becomeFirstResponder];
        return NO;
    }
    return YES;
}

@end
