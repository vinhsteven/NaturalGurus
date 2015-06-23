//
//  SignUpViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 6/23/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "SignUpViewController.h"

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
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.navigationController.navigationBarHidden = NO;
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.mainScrollView addGestureRecognizer:singleTap];
}

- (void) viewDidLayoutSubviews {
    
}

- (void) setupUI {
    self.navigationItem.title = @"Create Account";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
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
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Account Created" message:@"Your account has been created successfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [dialog show];
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
    [self.navigationController popViewControllerAnimated:YES];
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
        self.mainScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width, screenSize.height);
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.contentOffset.x, -44) animated:YES];
        
    }
    return YES;
}


@end
