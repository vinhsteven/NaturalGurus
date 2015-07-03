//
//  ForgotPasswordViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 6/23/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignUpViewController.h"

@interface ForgotPasswordViewController : UIViewController

@property (assign, readwrite) BOOL isFirstScreen;
@property (strong, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

- (IBAction) handleSubmit:(id)sender;
- (IBAction) closeView:(id)sender;

@end
