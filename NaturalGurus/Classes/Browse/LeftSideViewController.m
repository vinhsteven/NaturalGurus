//
//  LeftSideViewController.m
//  iTag
//
//  Created by Steven on 4/16/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import "LeftSideViewController.h"
#import "MMDrawerController.h"
#import "LoginViewController.h"
#import "DashboardViewController.h"
#import "MyProfileViewController.h"
#import "SignUpViewController.h"
#import "ForgotPasswordViewController.h"
#import "AppDelegate.h"

@interface LeftSideViewController ()

@end

@implementation LeftSideViewController
@synthesize parent;

-(BOOL)prefersStatusBarHidden{
    return YES;//HIDE_STATUS_BAR;
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
    
    mainArray = [NSMutableArray arrayWithCapacity:1];
    
    NSString *imageTitle[] = {
        @"iconDashboard.png",
        @"iconBrowse.png",
        @"iconProfile.png",
    };
    
    NSString *titleStr[] = {
        @"DASHBOARD",
        @"BROWSE",
        @"PROFILE",
    };
    
    userRole = [[ToolClass instance] getUserRole];
    if (userRole == isUser) {
        for (int i=0;i < sizeof(imageTitle)/sizeof(imageTitle[0]);i++) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",titleStr[i],@"title",imageTitle[i],@"image", nil];
            [mainArray addObject:dict];
        }
    }
    else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"index",titleStr[0],@"title",imageTitle[0],@"image", nil];
        [mainArray addObject:dict];
    }
    
    self.tableView.backgroundColor = [UIColor colorWithRed:(float)38/255 green:(float)38/255 blue:(float)38/255 alpha:1.0];
    self.tableView.rowHeight = 48;

    //check whether login or not
    
    BOOL isLogin = [[ToolClass instance] isLogin];
    if (isLogin)
        self.scrollView.hidden = YES;
    else
        self.scrollView.hidden = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.scrollView addGestureRecognizer:singleTap];
}

- (void) setupUI {
    screenSize = [UIScreen mainScreen].bounds.size;
    
    self.navigationController.navigationBarHidden = YES;
    
    UIView *navBorder = [[UIView alloc] initWithFrame:CGRectMake(0,self.navigationController.navigationBar.frame.size.height-1,self.navigationController.navigationBar.frame.size.width, 1)];
    
    // Change the frame size to suit yours //
    
    [navBorder setBackgroundColor:LINE_COLOR];
    [navBorder setOpaque:YES];
    [self.navigationController.navigationBar addSubview:navBorder];
    
    self.containerView.backgroundColor = [UIColor colorWithRed:(float)17/255 green:(float)17/255 blue:(float)17/255 alpha:1];
    self.containerView.layer.cornerRadius = 5;
    self.containerView.layer.masksToBounds = YES;
    self.containerView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.containerView.layer.borderWidth = 0.5;
    
    self.lbTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:16];
    self.lbTitle.textColor = GREEN_COLOR;
    
    self.btnLogout.titleLabel.font = [UIFont fontWithName:MONTSERRAT_BOLD size:13];
    
    //style for login form
    self.txtEmail.textAlignment = NSTextAlignmentLeft;
    self.txtPassword.textAlignment = NSTextAlignmentLeft;
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc]
                                           initWithString:@"Email"
                                           attributes:@{NSForegroundColorAttributeName:LIGHT_GREY_COLOR}];
    self.txtPassword.attributedPlaceholder    = [[NSAttributedString alloc]
                                                 initWithString:@"Password"
                                                 attributes:@{NSForegroundColorAttributeName:LIGHT_GREY_COLOR}];
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
    
    self.scrollView.backgroundColor = [UIColor colorWithRed:(float)38/255 green:(float)38/255 blue:(float)38/255 alpha:1];
    
    //set content size for iphone 4,4s
    if (screenSize.height == 480) {
        self.scrollView.scrollEnabled = YES;
        [self.scrollView setContentSize:CGSizeMake(280, 618)];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [mainArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    int index = [[dict objectForKey:@"index"] intValue];
    
    UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[dict objectForKey:@"image"]]];
    switch (index) {
        case kDashboardTag:
            img.frame = CGRectMake(28, 15, 16, 16);
            break;
        case kBrowseTag:
            img.frame = CGRectMake(28, 15, 13, 16);
            break;
        case kProfileTag:
            img.frame = CGRectMake(28, 15, 15, 16);
            break;
        default:
            break;
    }
    
    [cell.contentView addSubview:img];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(56, 15, 150, 21)];
    lbTitle.backgroundColor = [UIColor clearColor];
    lbTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    lbTitle.textColor = [UIColor whiteColor];
    lbTitle.text = [dict objectForKey:@"title"];
    [cell.contentView addSubview:lbTitle];
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = [mainArray objectAtIndex:indexPath.row];
    int index = [[dict objectForKey:@"index"] intValue];

    switch (index) {
        case kDashboardTag:
        {
            DashboardViewController *controller = [[DashboardViewController alloc] initWithNibName:@"DashboardViewController" bundle:nil];
            
            UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
            naviController.navigationBar.barStyle = UIBarStyleBlack;
            [self.mm_drawerController
             setCenterViewController:naviController
             withCloseAnimation:YES
             completion:nil];
            break;
        }
        case kBrowseTag:
        {
            BrowseViewController *controller = [[BrowseViewController alloc] initWithNibName:@"BrowseViewController" bundle:nil];
            
            UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
            naviController.navigationBar.barStyle = UIBarStyleBlack;
            [self.mm_drawerController
             setCenterViewController:naviController
             withCloseAnimation:YES
             completion:nil];
            break;
        }
        case kProfileTag:
        {
            MyProfileViewController *controller = [[MyProfileViewController alloc] initWithNibName:@"MyProfileViewController" bundle:nil];
            
            UINavigationController *naviController = [[UINavigationController alloc] initWithRootViewController:controller];
            naviController.navigationBar.barStyle = UIBarStyleBlack;
            [self.mm_drawerController
             setCenterViewController:naviController
             withCloseAnimation:YES
             completion:nil];
            break;
        }
        default:
            break;
    }
}

- (IBAction) handleLogout:(id)sender {
    [self performSelectorInBackground:@selector(synchronizeSignOutWithServer) withObject:nil];
    
    int loginType = [[ToolClass instance] getLoginType];
    
    switch (loginType) {
        case LOGIN_FACEBOOK:
            if (FBSession.activeSession.state == FBSessionStateOpen
                || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
                
                [[ToolClass instance] setLogin:NO];
                [[ToolClass instance] setUserToken:nil];
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                [FBSession.activeSession closeAndClearTokenInformation];
                
                [((LoginViewController*)parent).drawerController.navigationController popViewControllerAnimated:YES];
            }
            
            break;
        case LOGIN_EMAIL:
            [[ToolClass instance] setLogin:NO];
            [[ToolClass instance] setUserToken:nil];
            [((LoginViewController*)parent).drawerController.navigationController popViewControllerAnimated:YES];
            break;
        case LOGIN_TWITTER:
        {
            [[ToolClass instance] setLogin:NO];
            [[ToolClass instance] setUserToken:nil];
            [[Twitter sharedInstance] logOut];
            
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"];
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
            for (NSHTTPCookie *cookie in cookies)
            {
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
            
            ACAccountStore *accountStore = [[ACAccountStore alloc] init];
            
            for (ACAccount *account in accountStore.accounts) {
                [accountStore removeAccount:account withCompletionHandler:nil];
            }
            
            [((LoginViewController*)parent).drawerController.navigationController popViewControllerAnimated:YES];
        }
        default:
            break;
    }
}

- (void) synchronizeSignOutWithServer {
    NSString *token = [[ToolClass instance] getUserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    [[ToolClass instance] signOut:params];
}

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
                 
                 // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                 AppDelegate *delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
                 [delegate sessionStateChanged:session state:state error:error];
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
                    
                    // Retrieve the app delegate
                    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                    // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                    [appDelegate twitterStateChanged:session];
                    
                } else {
                    NSLog(@"error: %@", [error localizedDescription]);
                }
            }];
            
            break;
        }
        case kNaturalButton:
        {
            //hide keyboard
            [self handleSingleTap:nil];
            
            if ([self.txtEmail.text isEqualToString:@""]) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Email Required" message:@"Please input your email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
                return;
            }
            
            if (![[ToolClass instance] validateEmail:self.txtEmail.text]) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Wrong email format. Please input the correct email's format. For example: johndoe@gmail.com" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
                return;
            }
            
            if ([self.txtPassword.text isEqualToString:@""]) {
                UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Password Required" message:@"Please input your password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [dialog show];
                return;
            }
            
            //connect webservice to sign in
            NSString *deviceToken = [[ToolClass instance] getUserDeviceToken];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.txtEmail.text,@"email",self.txtPassword.text,@"password",deviceToken,@"device_token", nil];
            
            [[ToolClass instance] signIn:params withViewController:self];
        }
            break;
        default:
            break;
    }
    
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

- (void) loginSuccess {
    [[ToolClass instance] setLogin:YES];
    
    self.scrollView.hidden = YES;
    
    [mainArray removeAllObjects];
    
    NSString *imageTitle[] = {
        @"iconDashboard.png",
        @"iconBrowse.png",
        @"iconProfile.png",
    };
    
    NSString *titleStr[] = {
        @"DASHBOARD",
        @"BROWSE",
        @"PROFILE",
    };
    
    userRole = [[ToolClass instance] getUserRole];
    if (userRole == isUser) {
        for (int i=0;i < sizeof(imageTitle)/sizeof(imageTitle[0]);i++) {
            NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:i],@"index",titleStr[i],@"title",imageTitle[i],@"image", nil];
            [mainArray addObject:dict];
        }
    }
    else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"index",titleStr[0],@"title",imageTitle[0],@"image", nil];
        [mainArray addObject:dict];
    }
    
    [self.tableView reloadData];
}

- (IBAction) createAccount:(id)sender {
    SignUpViewController *controller = [[SignUpViewController alloc] initWithNibName:@"SignUpViewController" bundle:nil];
//    [((LoginViewController*)parent).drawerController.navigationController presentViewController:controller animated:YES completion:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction) handleForgotPassword:(id)sender {
    ForgotPasswordViewController *controller = [[ForgotPasswordViewController alloc] initWithNibName:@"ForgotPasswordViewController" bundle:nil];
    [((LoginViewController*)parent).drawerController.navigationController presentViewController:controller animated:YES completion:nil];
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

@end
