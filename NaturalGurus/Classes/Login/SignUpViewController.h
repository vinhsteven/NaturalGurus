//
//  SignUpViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 6/23/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTextField: UITextField

@property (assign,readwrite) float rightIconWidth;
@property (assign,readwrite) float rightIconHeight;

@end

@interface SignUpViewController : UIViewController <UITextFieldDelegate,UIScrollViewDelegate,UIAlertViewDelegate> {
    CGSize screenSize;
}

@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet CustomTextField *txtFirstname;
@property (strong, nonatomic) IBOutlet CustomTextField *txtLastname;
@property (strong, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (strong, nonatomic) IBOutlet CustomTextField *txtPassword;
@property (strong, nonatomic) IBOutlet CustomTextField *txtConfirmPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnCreateAccount;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction) handleConfirmCreateAccount:(id)sender;

@end
