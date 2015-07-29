//
//  WriteReviewViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 7/28/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WriteReviewViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate> {
    CGSize screenSize;
}

@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet UILabel *lbNameTitle;
@property (strong, nonatomic) IBOutlet UITextField *txtName;
@property (strong,nonatomic) IBOutlet EDStarRating *ratingView;
@property (strong, nonatomic) IBOutlet UITextView *txtMessage;

@property (assign,readwrite) long expertId;
@property (assign,readwrite) long orderId;

- (void) submitReviewSuccessful;

@end
