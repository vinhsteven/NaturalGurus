//
//  PaymentViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/8/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "PaymentViewController.h"
#import "ConfirmedViewController.h"

typedef enum {
    CREDIT_CARD_VISA,
    CREDIT_CARD_MASTER,
    CREDIT_CARD_AMERICAN_EXPRESS,
    CREDIT_CARD_DISCOVER,
    CREDIT_CARD_UNKNOWN
} CREDIT_CARD_TYPE;

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
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.scrollView addGestureRecognizer:singleTap];
    
    //fill data on label
    self.lbExpertName.text = [self.scheduleDict objectForKey:@"expertName"];
    self.lbTotalPrice.text = [NSString stringWithFormat:@"$%.2f",[[self.scheduleDict objectForKey:@"total"] floatValue]];
    self.lbDuration.text   = [NSString stringWithFormat:@"%d mins",[[self.scheduleDict objectForKey:@"duration"] intValue]];
    
    NSString *date = [[self.scheduleDict objectForKey:@"timeDict"] objectForKey:@"date_from"];
    date = [ToolClass dateByFormat:@"EEE, yyyy-MM-dd" dateString:date];
    self.lbDate.text = date;
    
    NSString *timeFrom  = [[self.scheduleDict objectForKey:@"timeDict"] objectForKey:@"from_time"];
    NSString *timeTo    = [[self.scheduleDict objectForKey:@"timeDict"] objectForKey:@"to_time"];
    
    
    timeFrom = [ToolClass convertHourToAM_PM:timeFrom];
    timeTo = [ToolClass convertHourToAM_PM:timeTo];
    
    self.lbTime.text = [NSString stringWithFormat:@"%@ - %@",timeFrom,timeTo];
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

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    [self.txtNameOnCard resignFirstResponder];
    [self.txtCardNumber resignFirstResponder];
    [self.txtCVV resignFirstResponder];
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
    NSLog(@"scheduleDict = %@",self.scheduleDict);
    
    if ([self.txtNameOnCard.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input your name on card" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    //check regex for card number
    // ^(?:4[0-9]{12}(?:[0-9]{3})? - VISA
    // 5[1-5][0-9]{14}             - MASTER
    // 3[47][0-9]{13}              - AMEX
    // 6(?:011|5[0-9]{2})[0-9]{12} - DISCOVER
    // (?:2131|1800|35\d{3})\d{11} - JCB
    
//    NSString *tmpCardNumber = [self.txtCardNumber.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
//    
//    NSString *regex[] = {
//        @"^4[0-9]{12}(?:[0-9]{3})?$",
//        @"^5[1-5][0-9]{14}$",
//        @"^3[47][0-9]{13}$",
//        @"^6(?:011|5[0-9]{2})[0-9]{12}$",
//    };
//    BOOL isValid = NO;
//    for (int i=0;i < sizeof(regex)/sizeof(regex[0]);i++) {
//        if ([[ToolClass instance] validateString:tmpCardNumber withPattern:regex[i]]) {
//            isValid = YES;
//            break;
//        }
//    }
//    if (!isValid) {
//        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Invalid card number. Please try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [dialog show];
//        return;
//    }
    
    //check input CVV
    if ([self.txtCVV.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please input CVV." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    self.stripeCard = [[STPCard alloc] init];
    self.stripeCard.name = self.txtNameOnCard.text;
    self.stripeCard.number = self.txtCardNumber.text;
    self.stripeCard.cvc = self.txtCVV.text;
    self.stripeCard.expMonth = [self.btnExpiredMonth.titleLabel.text integerValue];
    self.stripeCard.expYear = [self.btnExpiredYear.titleLabel.text integerValue];
    
    //check valid card info
    if ([self validateCustomerInfo]) {
        [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        [self performStripeOperation];
    }
//    ConfirmedViewController *controller = [[ConfirmedViewController alloc] initWithNibName:@"ConfirmedViewController" bundle:nil];
//    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)validateCustomerInfo {
    //1. Validate card number, CVC, expMonth, expYear
    NSError* error = nil;
    [self.stripeCard validateCardReturningError:&error];
    
    //2
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    
    return YES;
}

- (void)performStripeOperation {
    [Stripe setDefaultPublishableKey:STRIPE_PUBLISH_KEY];
    
    [[STPAPIClient sharedClient] createTokenWithCard:self.stripeCard completion:^(STPToken * __stp_nullable token, NSError * __stp_nullable error) {
        if (!error) {
            NSLog(@"token = %@",token.tokenId);
            //connect server to process payment
            NSDictionary *timeDict = [self.scheduleDict objectForKey:@"timeDict"];
            NSDictionary *params;

            if (self.isBookLive)
                params = [NSDictionary dictionaryWithObjectsAndKeys:[self.scheduleDict objectForKey:@"message"],@"about",[self.scheduleDict objectForKey:@"expertId"],@"expert_id",[self.scheduleDict objectForKey:@"duration"],@"duration",[self.scheduleDict objectForKey:@"timezone"],@"client_timezone",[self.scheduleDict objectForKey:@"total"],@"total",[timeDict objectForKey:@"date_from"],@"date",[timeDict objectForKey:@"from_time"],@"from_time",[timeDict objectForKey:@"to_time"],@"to_time",@"iOS",@"booked_from",[[ToolClass instance] getUserToken],@"token",token.tokenId,@"stripe_token",[self.scheduleDict objectForKey:@"live_request_id"],@"live_request_id",[NSNumber numberWithInt:0],@"free", nil];
            else
                params = [NSDictionary dictionaryWithObjectsAndKeys:[self.scheduleDict objectForKey:@"message"],@"about",[self.scheduleDict objectForKey:@"expertId"],@"expert_id",[self.scheduleDict objectForKey:@"duration"],@"duration",[self.scheduleDict objectForKey:@"timezone"],@"client_timezone",[self.scheduleDict objectForKey:@"total"],@"total",[timeDict objectForKey:@"date_from"],@"date",[timeDict objectForKey:@"from_time"],@"from_time",[timeDict objectForKey:@"to_time"],@"to_time",@"iOS",@"booked_from",[[ToolClass instance] getUserToken],@"token",[NSNumber numberWithInt:0],@"free",token.tokenId,@"stripe_token", nil];
            NSLog(@"param = %@",params);

            [[ToolClass instance] bookSchedule:params withViewController:self];
        }
        else {
            [MBProgressHUD hideAllHUDsForView:self.navigationController.view animated:YES];
            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:nil message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [dialog show];
        }
    }];
}

- (void) bookingSuccess:(long)orderId {
    if (!self.isBookLive) {
        ConfirmedViewController *controller = [[ConfirmedViewController alloc] initWithNibName:@"ConfirmedViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        DetailAppointmentViewController *controller = [[DetailAppointmentViewController alloc] initWithNibName:@"DetailAppointmentViewController" bundle:nil];
        controller.isPushNotification = YES;
        controller.appointmentId = orderId;
        [self.navigationController pushViewController:controller animated:YES];
        
        UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
        btnLeft.frame = CGRectMake(0, 0, 24, 24);
        [btnLeft setImage:[UIImage imageNamed:@"btnClose.png"] forState:UIControlStateNormal];
        [btnLeft addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
        controller.navigationItem.leftBarButtonItem = btnItem;
    }
}

- (void) closeView {
    [LiveRequestListViewController instance].isOpening = NO;
    [BookLiveViewController instance].isOpening = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.txtCardNumber)
        self.txtCVV.text = @"";
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.txtCardNumber || textField == self.txtCVV)  {
        //check regular expression for this field, only accept number
        NSString *pattern = @"^[0-9]";
        if ([string isEqualToString:@""])
            return YES;
        if (![[ToolClass instance] validateString:string withPattern:pattern])
            return NO;
        
        int cardType = [self getCreditCardTypeWithCardNumber:self.txtCardNumber.text];
        
        if (textField == self.txtCardNumber) {
            //check length for each card type
            //master and visa have 16 characters
            //AMEX has 15 characters
            NSString *seperatorLine = @"-";
            int numberSeperator;
            
            if (textField == self.txtCardNumber) {
                //check length of card number
                int cardLength;
                
                switch (cardType) {
                    case CREDIT_CARD_VISA:
                    case CREDIT_CARD_MASTER:
                    case CREDIT_CARD_DISCOVER:
                        cardLength = 16;
                        numberSeperator = 3;
                        if (textField.text.length == 4 || textField.text.length == 9 || textField.text.length == 14)
                            self.txtCardNumber.text = [textField.text stringByAppendingString:seperatorLine];
                        
                        break;
                    case CREDIT_CARD_AMERICAN_EXPRESS:
                        cardLength = 15;
                        numberSeperator = 2;
                        
                        if (textField.text.length == 4 || textField.text.length == 11)
                            self.txtCardNumber.text = [textField.text stringByAppendingString:seperatorLine];
                        
                        break;
                    default: {
                        if(self.txtCardNumber.text.length > 1) {
                            UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid card number" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                            [dialog show];
                            return NO;
                        }
                    }
                }
                if (textField.text.length >= cardLength + numberSeperator)
                    return NO;
            }
        }
        else {
            int numberDigit;
            switch (cardType) {
                case CREDIT_CARD_VISA:
                case CREDIT_CARD_MASTER:
                case CREDIT_CARD_DISCOVER:
                    numberDigit = 3;
                    break;
                case CREDIT_CARD_AMERICAN_EXPRESS:
                    numberDigit = 4;
                    break;
                default:
                    break;
            }
            if (textField.text.length >= numberDigit)
                return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.txtNameOnCard) {
        [self.txtCardNumber becomeFirstResponder];
    }
    else if (textField == self.txtCardNumber) {
        [self selectMonth:nil];
    }
    else if (textField == self.txtCVV) {
        [textField resignFirstResponder];
        [self confirmAppointment:nil];
    }
    return YES;
}

//- (CREDIT_CARD_TYPE) getCreditCardTypeWithCardNumber:(NSString*)cardNumber
//{
//    CREDIT_CARD_TYPE creditCardType = CREDIT_CARD_UNKNOWN;
//    
//    if ([cardNumber hasPrefix:@"4"]) {
//        creditCardType = CREDIT_CARD_VISA;
//    }
//    else if([cardNumber hasPrefix:@"50"] ||
//            [cardNumber hasPrefix:@"51"] ||
//            [cardNumber hasPrefix:@"52"] ||
//            [cardNumber hasPrefix:@"53"] ||
//            [cardNumber hasPrefix:@"54"] ||
//            [cardNumber hasPrefix:@"55"]){
//        creditCardType = CREDIT_CARD_MASTER;
//    }
//    else if([cardNumber hasPrefix:@"34"] ||
//            [cardNumber hasPrefix:@"37"]){
//        creditCardType = CREDIT_CARD_AMERICAN_EXPRESS;
//    }
//    else if([cardNumber hasPrefix:@"6011"] ||
//            [cardNumber hasPrefix:@"65"]){
//        creditCardType = CREDIT_CARD_DISCOVER;
//    }
//    else{
//        if (cardNumber.length >=3) {
//            NSString* prefix = [cardNumber substringWithRange: NSMakeRange(0, 3)];
//            int prefixNumber = [prefix intValue];
//            if (prefixNumber >= 644 && prefixNumber <= 649) {
//                creditCardType = CREDIT_CARD_DISCOVER;
//            }
//        }
//        if (cardNumber.length >=6){
//            NSString* prefix = [cardNumber substringWithRange: NSMakeRange(0, 6)];
//            int prefixNumber = [prefix intValue];
//            if (prefixNumber >= 622126 && prefixNumber <= 622925) {
//                creditCardType = CREDIT_CARD_DISCOVER;
//            }
//        }
//    }
//    
//    return creditCardType;
//}

- (CREDIT_CARD_TYPE) getCreditCardTypeWithCardNumber:(NSString*)cardNumber
{
    CREDIT_CARD_TYPE creditCardType = CREDIT_CARD_UNKNOWN;
    
    if ([cardNumber hasPrefix:@"4"]) {
        creditCardType = CREDIT_CARD_VISA;
    }
    else if([cardNumber hasPrefix:@"5"]){
        creditCardType = CREDIT_CARD_MASTER;
    }
    else if([cardNumber hasPrefix:@"3"]){
        creditCardType = CREDIT_CARD_AMERICAN_EXPRESS;
    }
    else if([cardNumber hasPrefix:@"6"]){
        creditCardType = CREDIT_CARD_DISCOVER;
    }
    
    return creditCardType;
}

@end
