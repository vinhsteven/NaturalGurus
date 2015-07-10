//
//  LeftSideViewController.h
//  iTag
//
//  Created by Steven on 4/16/14.
//  Copyright (c) 2014 NhuanQuang. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    kDashboardTag = 0,
    kBrowseTag,
    kProfileTag,
    kLogOutTag,
};

@interface LeftSideViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    CGSize screenSize;
    NSMutableArray *mainArray;
    int userRole;
}

@property (unsafe_unretained) id parent;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UIButton *btnLogout;

//login scroll view
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong,nonatomic) IBOutlet UITextField *txtEmail;
@property (strong,nonatomic) IBOutlet UITextField *txtPassword;
@property (strong,nonatomic) IBOutlet UIButton *btnCreateAccount;
@property (strong,nonatomic) IBOutlet UIButton *btnSignIn;


- (IBAction) handleLogout:(id)sender;

- (IBAction) loginButtonTapped:(id)sender;
- (IBAction) createAccount:(id)sender;
- (IBAction) handleForgotPassword:(id)sender;

@end
