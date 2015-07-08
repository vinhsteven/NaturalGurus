//
//  SignUpViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 6/23/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "SignUpViewController.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@implementation CustomTextField

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 10 , 10 );
}

// override rightViewRectForBounds method:
- (CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect rightBounds = CGRectMake(bounds.size.width - 30, 15, self.rightIconWidth, self.rightIconHeight);
    return rightBounds ;
}
@end

@interface SignUpViewController ()

@end

@implementation SignUpViewController

//- (BOOL)shouldAutorotate {
//    return NO;
//}
//
//- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
//    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
//}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.mainScrollView addGestureRecognizer:singleTap];
    
    countryCodeArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryCode" ofType:@"plist"]];
}

- (void) viewDidLayoutSubviews {
    if (screenSize.height == 480) {
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, screenSize.height+100);
    }
    else {
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, screenSize.height+20);
    }
    
    //check if this view is opened from Login Screen.
    if (_isFirstScreen)
        self.mainScrollView.frame = CGRectMake(self.mainScrollView.frame.origin.x, self.mainScrollView.frame.origin.y-64, self.mainScrollView.frame.size.width, self.mainScrollView.frame.size.height+64);
}

- (void) setupUI {
    self.navigationItem.title = @"Create Account";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    self.topView.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1.0];
    
    //add bottom line of top view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenSize.width, 1)];
    view.backgroundColor = LIGHT_GREY_COLOR;
    [self.topView addSubview:view];
    
    //style for title label
    self.lbTitle.textColor = GREEN_COLOR;
    self.lbTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:16];
    
    //set style for First name text field
    self.txtFirstname.backgroundColor = [UIColor whiteColor];
    self.txtFirstname.layer.cornerRadius = 5;
    self.txtFirstname.layer.masksToBounds = YES;
    self.txtFirstname.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.txtFirstname.layer.borderWidth = 1;
    
    UIImageView *iconProfile = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconProfile.png"]];
    
    [self.txtFirstname setRightViewMode:UITextFieldViewModeAlways];
    self.txtFirstname.rightView = iconProfile;
    self.txtFirstname.rightIconWidth  = iconProfile.frame.size.width;
    self.txtFirstname.rightIconHeight = iconProfile.frame.size.height;
    
    //set style for Last name text field
    self.txtLastname.backgroundColor = [UIColor whiteColor];
    self.txtLastname.layer.cornerRadius = 5;
    self.txtLastname.layer.masksToBounds = YES;
    self.txtLastname.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.txtLastname.layer.borderWidth = 1;
    
    UIImageView *iconProfile2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconProfile.png"]];
    [self.txtLastname setRightViewMode:UITextFieldViewModeAlways];
    self.txtLastname.rightView = iconProfile2;
    
    self.txtLastname.rightIconWidth  = iconProfile2.frame.size.width;
    self.txtLastname.rightIconHeight = iconProfile2.frame.size.height;
    
    //set style for Email text field
    self.txtEmail.backgroundColor = [UIColor whiteColor];
    self.txtEmail.layer.cornerRadius = 5;
    self.txtEmail.layer.masksToBounds = YES;
    self.txtEmail.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.txtEmail.layer.borderWidth = 1;
    
    UIImageView *iconEmail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconEmail.png"]];

    [self.txtEmail setRightViewMode:UITextFieldViewModeAlways];
    self.txtEmail.rightView = iconEmail;
    self.txtEmail.rightIconWidth  = iconEmail.frame.size.width;
    self.txtEmail.rightIconHeight = iconEmail.frame.size.height;
    
    //set style for Email text field
    self.txtCountryCode.backgroundColor = [UIColor whiteColor];
    self.txtCountryCode.layer.cornerRadius = 5;
    self.txtCountryCode.layer.masksToBounds = YES;
    self.txtCountryCode.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.txtCountryCode.layer.borderWidth = 1;
    
    //set style for Email text field
    self.txtPhone.backgroundColor = [UIColor whiteColor];
    self.txtPhone.layer.cornerRadius = 5;
    self.txtPhone.layer.masksToBounds = YES;
    self.txtPhone.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.txtPhone.layer.borderWidth = 1;
    
    //set style for Container Password & Confirm Password
    self.containerView.backgroundColor = [UIColor whiteColor];
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.containerView.layer.borderWidth = 1;
    
    UIImageView *iconKey = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconKey.png"]];
    UIImageView *iconKey2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconKey.png"]];
    
    [self.txtPassword setRightViewMode:UITextFieldViewModeAlways];
    self.txtPassword.rightView = iconKey;
    self.txtPassword.rightIconWidth  = iconKey.frame.size.width;
    self.txtPassword.rightIconHeight = iconKey.frame.size.height;
    
    [self.txtConfirmPassword setRightViewMode:UITextFieldViewModeAlways];
    self.txtConfirmPassword.rightView = iconKey2;
    self.txtConfirmPassword.rightIconWidth  = iconKey2.frame.size.width;
    self.txtConfirmPassword.rightIconHeight = iconKey2.frame.size.height;
    
    //set style for Create Account button
    self.btnCreateAccount.backgroundColor = [UIColor whiteColor];
    self.btnCreateAccount.layer.cornerRadius = 5;
    self.btnCreateAccount.layer.masksToBounds = YES;
    self.btnCreateAccount.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    [self.btnCreateAccount setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    [self.btnCreateAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

}

- (IBAction) handleConfirmCreateAccount:(id)sender {
    if ([self.txtFirstname.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your first name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if ([self.txtLastname.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your last name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if ([self.txtEmail.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if ([self.txtPassword.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if (![self.txtConfirmPassword.text isEqualToString:self.txtPassword.text]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Password doesn't match. Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    //connect server to call webservice for registering
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:self.txtFirstname.text,@"firstname",self.txtLastname.text,@"lastname",self.txtEmail.text,@"email",self.txtPassword.text,@"password", nil];
    [[ToolClass instance] registerAccount:parameters withViewController:self];
}

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    [self.txtFirstname resignFirstResponder];
    [self.txtLastname resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtConfirmPassword resignFirstResponder];
    
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, screenSize.height);
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (self.isFirstScreen)
        [self.navigationController popViewControllerAnimated:YES];
    else
        [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, screenSize.height+300);
    
    CGRect rect = [textField bounds];
    rect = [textField convertRect:rect toView:self.mainScrollView];
    rect.origin.x = 0 ;
    rect.origin.y -= 60 ;
    rect.size.height = 400;
    
    [self.mainScrollView scrollRectToVisible:rect animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtFirstname) {
        [self.txtLastname becomeFirstResponder];
    }
    else if (textField == self.txtLastname) {
        [self.txtEmail becomeFirstResponder];
        
    }
    else if (textField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
    }
    else if (textField == self.txtPassword) {
        [self.txtConfirmPassword becomeFirstResponder];
    }
    else if (textField == self.txtConfirmPassword) {
        [textField resignFirstResponder];
        if (screenSize.height == 480)
            self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, screenSize.height+100);
        else
            self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, screenSize.height);
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, -44) animated:YES];
        
        //handle register account
        [self handleConfirmCreateAccount:nil];
    }
    return YES;
}

- (IBAction) closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
