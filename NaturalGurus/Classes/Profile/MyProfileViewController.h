//
//  MyProfileViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface MyProfileViewController : UIViewController <UITextFieldDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate>{
    
    CGSize screenSize;
    CGPoint originalPoint;
    
    NSMutableArray *countryCodeArray;
    int currentCountrySelected;
    
    BOOL isChangeAvatar;
}

@property (strong, nonatomic) IBOutlet UIImageView *imgExpertView;
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtCountryCode;
@property (strong, nonatomic) IBOutlet UITextField *txtPhoneNumber;
@property (strong, nonatomic) IBOutlet UISwitch *switchPushNotification;
@property (strong, nonatomic) IBOutlet UISwitch *switchSMS;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction) handleEditProfile:(UIButton*)sender;
- (IBAction) handleEditProfileImage:(id)sender;
- (IBAction) handleSwitchChange:(UISwitch*)sender;

@end
