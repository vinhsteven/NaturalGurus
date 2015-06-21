//
//  MyProfileViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface MyProfileViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    CGSize screenSize;
    
    UITextField *txtFirstName;
    UITextField *txtLastName;
    UITextField *txtEmail;
    UITextField *txtCountryCode;
    UITextField *txtPhoneNumber;
    
    UISwitch *switchPushNotification;
    UISwitch *switchSMS;
    
    UIButton *btnSave;
}

@property (strong, nonatomic) IBOutlet TPKeyboardAvoidingTableView *mainTableView;
@property (strong, nonatomic) IBOutlet UIImageView *imgExpertView;

- (IBAction) handleEditProfileImage:(id)sender;

@end
