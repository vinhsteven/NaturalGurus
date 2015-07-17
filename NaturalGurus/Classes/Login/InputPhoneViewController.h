//
//  InputPhoneViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 7/17/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputPhoneViewController : UIViewController <UITextFieldDelegate> {
    NSMutableArray *countryCodeArray;
    int currentCountrySelected;
}

@property (unsafe_unretained) id parent;
@property (strong, nonatomic) NSMutableDictionary *params;
@property (strong, nonatomic) IBOutlet CustomTextField *txtCountryCode;
@property (strong, nonatomic) IBOutlet CustomTextField *txtPhone;
@property (strong, nonatomic) IBOutlet UIButton *btnContinue;
@property (strong, nonatomic) IBOutlet UIView *topView;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;

- (IBAction) handleNext:(id)sender;

@end
