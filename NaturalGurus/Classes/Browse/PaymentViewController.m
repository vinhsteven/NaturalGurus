//
//  PaymentViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/8/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "PaymentViewController.h"
#import "ConfirmedViewController.h"

@interface PaymentViewController ()

@end

@implementation PaymentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    screenSize = [UIScreen mainScreen].bounds.size;
    
    [self setupUI];

    monthArray = [NSMutableArray arrayWithCapacity:1];
    for (int i=0;i < 12;i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%02d",i+1],@"title",[NSString stringWithFormat:@"%02d",i+1],@"value", nil];
        [monthArray addObject:dict];
    }
    
    yearArray = [NSMutableArray arrayWithCapacity:1];
    for (int i=2015;i < 2050;i++) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",i],@"title",[NSString stringWithFormat:@"%d",i],@"value", nil];
        [yearArray addObject:dict];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationItem.title = @"Payment";
}

- (void) viewDidLayoutSubviews {
    if (screenSize.height == 568) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+100)];
    }
    else if (screenSize.height == 480) {
        [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.scrollView.frame.size.height+200)];
    }
}

- (void) setupUI {
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.btnConfirm.layer.cornerRadius  = 5;
    self.btnConfirm.layer.masksToBounds = YES;
    self.btnConfirm.layer.borderWidth   = 1;
    self.btnConfirm.layer.borderColor   = [UIColor lightGrayColor].CGColor;
    self.btnConfirm.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    [self.btnConfirm setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnConfirm setTitle:@"Confirm Appointment" forState:UIControlStateNormal];
    [self.btnConfirm setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    
    self.txtNameOnCard.layer.cornerRadius   = 5;
    self.txtNameOnCard.layer.masksToBounds  = YES;
    self.txtNameOnCard.layer.borderWidth    = 1;
    self.txtNameOnCard.layer.borderColor    = [UIColor lightGrayColor].CGColor;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    leftView.backgroundColor = [UIColor clearColor];
    self.txtNameOnCard.leftViewMode = UITextFieldViewModeAlways;
    self.txtNameOnCard.leftView = leftView;
    
    self.txtCardNumber.layer.cornerRadius   = 5;
    self.txtCardNumber.layer.masksToBounds  = YES;
    self.txtCardNumber.layer.borderWidth    = 1;
    self.txtCardNumber.layer.borderColor    = [UIColor lightGrayColor].CGColor;
    UIView *leftView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    leftView2.backgroundColor = [UIColor clearColor];
    self.txtCardNumber.leftViewMode = UITextFieldViewModeAlways;
    self.txtCardNumber.leftView = leftView2;
    
    self.txtCVV.layer.cornerRadius   = 5;
    self.txtCVV.layer.masksToBounds  = YES;
    self.txtCVV.layer.borderWidth    = 1;
    self.txtCVV.layer.borderColor    = [UIColor lightGrayColor].CGColor;
    
    self.btnExpiredMonth.layer.cornerRadius   = 5;
    self.btnExpiredMonth.layer.masksToBounds  = YES;
    self.btnExpiredMonth.layer.borderWidth    = 1;
    self.btnExpiredMonth.layer.borderColor    = [UIColor lightGrayColor].CGColor;
    [self.btnExpiredMonth setBackgroundImage:[ToolClass imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    self.btnExpiredYear.layer.cornerRadius   = 5;
    self.btnExpiredYear.layer.masksToBounds  = YES;
    self.btnExpiredYear.layer.borderWidth    = 1;
    self.btnExpiredYear.layer.borderColor    = [UIColor lightGrayColor].CGColor;
    [self.btnExpiredYear setBackgroundImage:[ToolClass imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    self.containerView.layer.cornerRadius   = 5;
    self.containerView.layer.masksToBounds  = YES;
    self.containerView.layer.borderWidth    = 1;
    self.containerView.layer.borderColor    = [UIColor lightGrayColor].CGColor;
}

- (IBAction) selectMonth:(id)sender {
    [self.txtNameOnCard resignFirstResponder];
    [self.txtCardNumber resignFirstResponder];
    [self.txtCVV resignFirstResponder];
    
    [MMPickerView showPickerViewInView:self.view
                           withObjects:monthArray
                           withOptions:nil
                            completion:^(NSInteger selectedIndex) {
                                //return selected index
                                currentMonthIndex = (int)selectedIndex;
                                
                                NSDictionary *dict = [monthArray objectAtIndex:currentMonthIndex];
                                [self.btnExpiredMonth setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
                            }];
}

- (IBAction) selectYear:(id)sender {
    [self.txtNameOnCard resignFirstResponder];
    [self.txtCardNumber resignFirstResponder];
    [self.txtCVV resignFirstResponder];
    
    [MMPickerView showPickerViewInView:self.view
                           withObjects:yearArray
                           withOptions:nil
                            completion:^(NSInteger selectedIndex) {
                                //return selected index
                                currentYearIndex = (int)selectedIndex;
                                
                                NSDictionary *dict = [yearArray objectAtIndex:currentYearIndex];
                                [self.btnExpiredYear setTitle:[dict objectForKey:@"title"] forState:UIControlStateNormal];
                            }];
}

- (IBAction) confirmAppointment:(id)sender {
    ConfirmedViewController *controller = [[ConfirmedViewController alloc] initWithNibName:@"ConfirmedViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}


@end
