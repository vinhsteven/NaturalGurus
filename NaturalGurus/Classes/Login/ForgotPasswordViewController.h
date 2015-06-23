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

@property (strong, nonatomic) IBOutlet CustomTextField *txtEmail;
@property (strong, nonatomic) IBOutlet UIButton *btnSubmit;

- (IBAction) handleSubmit:(id)sender;

@end
