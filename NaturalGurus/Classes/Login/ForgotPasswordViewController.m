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
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    
    [self setupUI];
}

- (void) setupUI {
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    self.navigationItem.title = @"Restore Password";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    self.topView.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1.0];
    
    //add bottom line of top view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenSize.width, 1)];
    view.backgroundColor = LIGHT_GREY_COLOR;
    [self.topView addSubview:view];
    
    //style for title label
    self.lbTitle.textColor = GREEN_COLOR;
    self.lbTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:16];
    
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
    if ([self.txtEmail.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if (![[ToolClass instance] validateEmail:self.txtEmail.text]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Wrong email format. Please input the correct email's format. For example: johndoe@gmail.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    //connect webservice to reset password
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.txtEmail.text,@"email", nil];
    [[ToolClass instance] requestResetPassword:params withViewController:self];
}

- (IBAction) closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
