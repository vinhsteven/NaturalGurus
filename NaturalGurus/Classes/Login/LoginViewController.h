//
//  ViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/9/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constant.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "MMDrawerController.h"
#import "BrowseViewController.h"

@interface LoginViewController : UIViewController <FBSDKLoginButtonDelegate,UITextFieldDelegate,UIScrollViewDelegate> {
    CGSize screenSize;
}

@property (nonatomic,strong) MMDrawerController * drawerController;
@property (strong,nonatomic) BrowseViewController *centerViewController;
@property (strong,nonatomic) IBOutlet UITextField *txtEmail;
@property (strong,nonatomic) IBOutlet UITextField *txtPassword;
@property (strong,nonatomic) IBOutlet UIButton *btnCreateAccount;
@property (strong,nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong,nonatomic) IBOutlet UIScrollView *mainScrollView;

- (IBAction) loginButtonTapped:(id)sender;
- (IBAction) skipStep:(id)sender;
- (IBAction) createAccount:(id)sender;
- (IBAction) handleForgotPassword:(id)sender;

@end

