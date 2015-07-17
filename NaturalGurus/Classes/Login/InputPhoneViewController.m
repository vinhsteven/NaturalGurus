//
//  InputPhoneViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/17/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "InputPhoneViewController.h"
#import "LoginViewController.h"

@interface InputPhoneViewController ()

@end

@implementation InputPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.title = @"Input Phone";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.topView.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1.0];
    
    //add bottom line of top view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = LIGHT_GREY_COLOR;
    [self.topView addSubview:view];
    
    //style for title label
    self.lbTitle.textColor = GREEN_COLOR;
    self.lbTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:16];
    
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
    
    self.btnContinue.backgroundColor = [UIColor whiteColor];
    self.btnContinue.layer.cornerRadius = 5;
    self.btnContinue.layer.masksToBounds = YES;
    self.btnContinue.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    [self.btnContinue setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    [self.btnContinue setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
    
    countryCodeArray = [NSMutableArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"CountryCode" ofType:@"plist"]];
}

- (void) hideKeyboard {
    [self.txtPhone resignFirstResponder];
    [self.txtCountryCode resignFirstResponder];
}

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    [self hideKeyboard];
}

- (IBAction) handleNext:(id)sender {
    
    if ([self.txtCountryCode.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please select your country code" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if ([self.txtPhone.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your phone number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    //connect server to call webservice for registering
    NSString *countryCode = [[countryCodeArray objectAtIndex:currentCountrySelected] objectForKey:@"value"];
    [self.params setValue:countryCode forKey:@"phone_code"];
    [self.params setValue:self.txtPhone.text forKey:@"phone"];
    
    [MBProgressHUD showHUDAddedTo:((LoginViewController*)_parent).navigationController.view animated:YES];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@",BASE_URL];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:urlStr]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager POST:@"/api/v1/sign_in/social" parameters:self.params success:^(NSURLSessionDataTask *task, id responseObject) {
        // 3
        NSLog(@"response: %@",(NSDictionary*)responseObject);
        //get status of request
        int status = [[responseObject objectForKey:@"status"] intValue];
        
        if (status == 200) {
            NSDictionary *data = [responseObject objectForKey:@"data"];
            
            //                     NSLog(@"token = %@",[[data objectForKey:@"token"] substringToIndex:100]);
            
            NSString *defaultUserImg = [data objectForKey:@"avatar"];
            defaultUserImg = [defaultUserImg stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            //save current user logged in informations
            //set current profile image
            [[ToolClass instance] setLogin:YES];
            
            [[ToolClass instance] setUserFirstName:[data objectForKey:@"firstname"]];
            [[ToolClass instance] setUserLastName:[data objectForKey:@"lastname"]];
            [[ToolClass instance] setUserRole:isUser];
            [[ToolClass instance] setUserToken:[data objectForKey:@"token"]];
            [[ToolClass instance] setUserEmail:[self.params objectForKey:@"email"]];
            [[ToolClass instance] setUserCountryCode:[data objectForKey:@"phone_code"]];
            [[ToolClass instance] setUserPhone:[data objectForKey:@"phone"]];
            [[ToolClass instance] setUserSMS:YES];
            [[ToolClass instance] setUserPush:YES];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            [(LoginViewController*)_parent loginSuccess];
        }
        else {
            NSString *message = [responseObject objectForKey:@"message"];
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
        }
        
        [MBProgressHUD hideAllHUDsForView:((LoginViewController*)_parent).navigationController.view animated:YES];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"FB failed: %@",error);
        [MBProgressHUD hideAllHUDsForView:((LoginViewController*)_parent).navigationController.view animated:YES];
    }];
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.txtCountryCode) {
        [self hideKeyboard];
        [MMPickerView showPickerViewInView:self.view
                               withObjects:countryCodeArray
                               withOptions:nil
                                completion:^(NSInteger selectedIndex) {
                                    //return selected index
                                    currentCountrySelected = (int)selectedIndex;
                                    
                                    NSDictionary *dict = [countryCodeArray objectAtIndex:currentCountrySelected];
                                    self.txtCountryCode.text = [NSString stringWithFormat:@"+%@",[dict objectForKey:@"value"]];
                                    [self.txtCountryCode resignFirstResponder];
                                    
                                    [self.txtPhone becomeFirstResponder];
                                }];
        return NO;
    }
    return YES;
}
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    //check if select country code text field
////    if (textField == self.txtCountryCode) {
////        [MMPickerView showPickerViewInView:self.view
////                               withObjects:countryCodeArray
////                               withOptions:nil
////                                completion:^(NSInteger selectedIndex) {
////                                    [self hideKeyboard];
////                                    
////                                    //return selected index
////                                    currentCountrySelected = (int)selectedIndex;
////                                    
////                                    NSDictionary *dict = [countryCodeArray objectAtIndex:currentCountrySelected];
////                                    self.txtCountryCode.text = [NSString stringWithFormat:@"+%@",[dict objectForKey:@"value"]];
////                                    [self.txtCountryCode resignFirstResponder];
////                                }];
//    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtPhone) {
        [textField resignFirstResponder];
        [self handleNext:nil];
    }
    return YES;
}

@end
