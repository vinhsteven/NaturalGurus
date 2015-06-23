//
//  ForgotPasswordViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 6/23/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "ForgotPasswordViewController.h"


@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    
    [self setupUI];
}

- (void) setupUI {
    self.navigationItem.title = @"Restore Password";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
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
    
    //set style for Submit button
    self.btnSubmit.backgroundColor = [UIColor whiteColor];
    self.btnSubmit.layer.cornerRadius = 5;
    self.btnSubmit.layer.masksToBounds = YES;
    self.btnSubmit.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    [self.btnSubmit setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    [self.btnSubmit setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction) handleSubmit:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"An email has been sent to your email. Please follow the instruction to get your password." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [dialog show];
}

@end
