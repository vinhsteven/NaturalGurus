//
//  ViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/9/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "LoginViewController.h"
#import "BrowseViewController.h"
#import "LeftSideViewController.h"
#import "MMDrawerVisualState.h"
#import "MMExampleDrawerVisualStateManager.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize centerViewController;

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //hide navigation bar for this screen
//    self.navigationController.navigationBarHidden = YES;
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.navigationItem.title = @"";
    
    self.txtEmail.textAlignment = NSTextAlignmentLeft;
    self.txtPassword.textAlignment = NSTextAlignmentLeft;
    //add icon image to text field
    UIImageView *iconEmail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconEmail.png"]];
    
    [self.txtEmail setRightViewMode:UITextFieldViewModeAlways];
    self.txtEmail.rightView = iconEmail;
    
    UIImageView *iconKey = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconKey.png"]];
    
    [self.txtPassword setRightViewMode:UITextFieldViewModeAlways];
    self.txtPassword.rightView = iconKey;
    
    //set style for create account button
    self.btnCreateAccount.layer.cornerRadius  = 5;
    self.btnCreateAccount.layer.masksToBounds = YES;
    self.btnCreateAccount.contentMode = UIViewContentModeScaleAspectFill;
    [self.btnCreateAccount setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    
    //set style for Sign In button
    [self.btnSignIn setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];

    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 290, 45) byRoundingCorners:(UIRectCornerBottomLeft | UIRectCornerBottomRight) cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path  = maskPath.CGPath;
    self.btnSignIn.layer.mask = maskLayer;
    
    self.mainScrollView.scrollEnabled = NO;
    //set content size for iphone 4,4s
    if (screenSize.height == 480) {
        self.mainScrollView.scrollEnabled = YES;
        [self.mainScrollView setContentSize:CGSizeMake(screenSize.width, 618)];
    }
    else if (screenSize.height == 568) {
        [self.mainScrollView setContentSize:CGSizeMake(screenSize.width, 648)];
        [self.mainScrollView setContentOffset:CGPointMake(self.mainScrollView.frame.origin.x, 40)];
    }
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.mainScrollView addGestureRecognizer:singleTap];
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

//skip this step
- (IBAction) skipStep:(id)sender {
    [[ToolClass instance] setLogin:NO];
    
    LeftSideViewController *leftViewController = [[LeftSideViewController alloc] init];
    leftViewController.parent = self;
    
    centerViewController = [[BrowseViewController alloc] initWithNibName:@"BrowseViewController" bundle:nil];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
//    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    UINavigationController * leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    leftNavigationController.navigationBar.barStyle = UIBarStyleDefault;
    [leftNavigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftNavigationController
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:280];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [self.navigationController pushViewController:self.drawerController animated:YES];
    
    leftViewController.parent = self;
}

//handle login button tap
- (IBAction) loginButtonTapped:(id)sender {
    UIButton *btnLogin = (UIButton*)sender;
    switch (btnLogin.tag) {
        case kFacebookButton:
        {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"]
                                               allowLoginUI:YES
                                          completionHandler:
             ^(FBSession *session, FBSessionState state, NSError *error) {
                 
                 // Retrieve the app delegate
                 AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                 // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                 [appDelegate sessionStateChanged:session state:state error:error];
             }];
            
            break;
        }
        case kTwitterButton:
        {
            [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
                if (session) {
                    NSLog(@"signed in as %@", [session userName]);
                    
                    //login twitter success
                    [[ToolClass instance] setLoginType:LOGIN_TWITTER];
                    
                    
                    if ([[Twitter sharedInstance] session]) {
                        TWTRShareEmailViewController* shareEmailViewController = [[TWTRShareEmailViewController alloc] initWithCompletion:^(NSString* email, NSError* error) {
                            NSLog(@"Email %@, Error: %@", email, error);
                            if (error.code == 2) {
                                //user denies sharing email
                                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Something Wrong" message:@"You must agree to share your email with us to access NaturalGurus" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [dialog show];
                            }
                            else if (error.code == -1003) {
                                //cannot find the server
                                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Server not found" message:@"A server with the specified hostname could not be found. Please check whether your network blocks Twitter or not." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [dialog show];
                            }
                            else if (error.code == 37) {
                                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"API Calling Error" message:@"Your application may not have access to email addresses or the user may not have an email address. To request access, please visit https://support.twitter.com/forms/platform." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                [dialog show];
                            }
                        }];
                        
                        [self presentViewController:shareEmailViewController animated:YES completion:nil];
                    }
                    else {
                        // TODO: Handle user not signed in (e.g. attempt to log in or show an alert)
                    }
                    
                    /* Get user info */
                    [[[Twitter sharedInstance] APIClient] loadUserWithID:[session userID]
                                                              completion:^(TWTRUser *user,
                                                                           NSError *error)
                     {
                         // handle the response or error
                         if (![error isEqual:nil]) {
                             NSString *profileImageURL = user.profileImageURL;
                             [[ToolClass instance] setProfileImageURL:profileImageURL];
                         } else {
                             NSLog(@"Twitter error getting profile : %@", [error localizedDescription]);
                         }
                     }];

                    
                } else {
                    NSLog(@"error: %@", [error localizedDescription]);
                }
            }];
            break;
        }
        case kNaturalButton:
        {
            if ([self.txtEmail.text isEqualToString:@""]) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Email Required" message:@"Please input your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
                return;
            }
            
            if ([self.txtPassword.text isEqualToString:@""]) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Password Required" message:@"Please input your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
                return;
            }
            
            //connect webservice to sign in
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.txtEmail.text,@"email",self.txtPassword.text,@"password", nil];
            
            [[ToolClass instance] signIn:params withViewController:self];
        
            break;
        }
        default:
            break;
    }
}

- (void) loginSuccess {    
    LeftSideViewController *leftViewController = [[LeftSideViewController alloc] initWithNibName:@"LeftSideViewController" bundle:nil];
    
    centerViewController = [[BrowseViewController alloc] initWithNibName:@"BrowseViewController" bundle:nil];
    
    UINavigationController * navigationController = [[UINavigationController alloc] initWithRootViewController:centerViewController];
    navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [navigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    UINavigationController * leftNavigationController = [[UINavigationController alloc] initWithRootViewController:leftViewController];
    leftNavigationController.navigationBar.barStyle = UIBarStyleBlack;
    [leftNavigationController setRestorationIdentifier:@"MMExampleCenterNavigationControllerRestorationKey"];
    
    self.drawerController = [[MMDrawerController alloc]
                             initWithCenterViewController:navigationController
                             leftDrawerViewController:leftNavigationController
                             rightDrawerViewController:nil];
    [self.drawerController setShowsShadow:NO];
    
    [self.drawerController setRestorationIdentifier:@"MMDrawer"];
    [self.drawerController setMaximumLeftDrawerWidth:280];
    [self.drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [self.drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    [self.drawerController
     setDrawerVisualStateBlock:^(MMDrawerController *drawerController, MMDrawerSide drawerSide, CGFloat percentVisible) {
         MMDrawerControllerDrawerVisualStateBlock block;
         block = [[MMExampleDrawerVisualStateManager sharedManager]
                  drawerVisualStateBlockForDrawerSide:drawerSide];
         if(block){
             block(drawerController, drawerSide, percentVisible);
         }
     }];
    
    [self.navigationController pushViewController:self.drawerController animated:YES];
    
    leftViewController.parent = self;
}

//handle create account
- (IBAction) createAccount:(id)sender {
    SignUpViewController *controller = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
    controller.isFirstScreen = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction) handleForgotPassword:(id)sender {
    ForgotPasswordViewController *controller = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    controller.isFirstScreen = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scroll: %f %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}

#pragma mark UITextFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtEmail)
        [self.txtPassword becomeFirstResponder];
    else {
        [textField resignFirstResponder];
        [self loginButtonTapped:self.btnSignIn];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
