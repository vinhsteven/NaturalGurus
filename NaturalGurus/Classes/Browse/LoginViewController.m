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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //hide navigation bar for this screen
//    self.navigationController.navigationBarHidden = YES;
    screenSize = [[UIScreen mainScreen] bounds].size;
    
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
//    [self.btnCreateAccount setBackgroundImage:[ToolClass imageFromColor:BOLD_GREEN_COLOR] forState:UIControlStateHighlighted];
    
    //set style for Sign In button
    [self.btnSignIn setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
//    [self.btnSignIn setBackgroundImage:[ToolClass imageFromColor:BOLD_GREEN_COLOR] forState:UIControlStateHighlighted];

//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.btnSignIn.bounds byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight) cornerRadii:CGSizeMake(5.0, 5.0)];

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
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;
}

//skip this step
- (IBAction) skipStep:(id)sender {
    LeftSideViewController *leftViewController = [[LeftSideViewController alloc] init];
    
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
    [self.drawerController setMaximumLeftDrawerWidth:160];
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
            break;
        case kGoogleButton:
            break;
        default:
            break;
    }
    [self loginSuccess];
}

- (void) loginSuccess {
    LeftSideViewController *leftViewController = [[LeftSideViewController alloc] init];
    
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
    [self.drawerController setMaximumLeftDrawerWidth:160];
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
    
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"scroll: %f %f",scrollView.contentOffset.x,scrollView.contentOffset.y);
}

#pragma mark FBSDKLoginButtonDelegate
- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
                error:(NSError *)error {
    NSLog(@"permission = %@",result.grantedPermissions);
    if ([result.grantedPermissions containsObject:@"public_profile"]) {
        [self loginSuccess];
    }
}

#pragma mark UITextFieldDelegate 
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtEmail)
        [self.txtPassword becomeFirstResponder];
    else
        [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
