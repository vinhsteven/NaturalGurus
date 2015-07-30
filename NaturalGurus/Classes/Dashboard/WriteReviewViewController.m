//
//  WriteReviewViewController.m
//  NaturalGurus
//
//  Created by Steven Pham on 7/28/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "WriteReviewViewController.h"

@interface WriteReviewViewController ()

@end

@implementation WriteReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupUI];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleTap];
}

- (void) setupUI {
    screenSize = [UIScreen mainScreen].bounds.size;
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    self.navigationItem.title = @"Write a Review";
    
    self.ratingView.backgroundImage = nil;
    self.ratingView.starImage = [UIImage imageNamed:@"big_star"];
    self.ratingView.starHighlightedImage = [UIImage imageNamed:@"big_star_highlighted.png"];
    self.ratingView.maxRating = 5.0;
    self.ratingView.horizontalMargin = 0;
    self.ratingView.editable    = YES;
    self.ratingView.displayMode = EDStarRatingDisplayAccurate;
    
    UIButton *btnClose = [UIButton buttonWithType:UIButtonTypeCustom];
    btnClose.frame = CGRectMake(0, 0, 24, 24);
    [btnClose setBackgroundImage:[UIImage imageNamed:@"btnClose.png"] forState:UIControlStateNormal];
    [btnClose addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *btnLeftItem = [[UIBarButtonItem alloc] initWithCustomView:btnClose];
    self.navigationItem.leftBarButtonItem = btnLeftItem;
    
    UIBarButtonItem *btnRightItem = [[UIBarButtonItem alloc] initWithTitle:@"Submit" style:UIBarButtonItemStyleDone target:self action:@selector(submitReview)];
    self.navigationItem.rightBarButtonItem = btnRightItem;
    
    self.txtMessage.text = @"";
    
    NSString *firstName = [[ToolClass instance] getUserFirstName];
    NSString *lastName  = [[ToolClass instance] getUserLastName];
    
    self.txtName.text = [NSString stringWithFormat:@"%@ %@",firstName,lastName];
    
    int userRole = [[ToolClass instance] getUserRole];
    if (userRole == isUser) {
        self.lbTitle.text = @"How was your experience with our expert?";
        self.txtName.text = @"";
        self.lbNameTitle.text  = @"Title";
    }
}

- (void) closeView {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) submitReview {
    if ([self.txtName.text isEqualToString:@""]) {
        int userRole = [[ToolClass instance] getUserRole];
        NSString *title;
        if (userRole == isUser)
            title = @"Please input your title.";
        else
            title = @"Please input your name.";
        
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:title delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if (self.ratingView.rating == 0) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please give us your rating." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if ([self.txtMessage.text isEqualToString:@""]) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"Please give us your comment." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    if (self.txtMessage.text.length < 10) {
        UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"The content must be at least 10 characters." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [dialog show];
        return;
    }
    
    NSDictionary *params;
    
    int userRole = [[ToolClass instance] getUserRole];
    NSString *token = [[ToolClass instance] getUserToken];
    if (userRole == isUser) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token",self.txtName.text,@"title",self.txtMessage.text,@"content",[NSNumber numberWithFloat:self.ratingView.rating],@"rate",[NSNumber numberWithLong:self.expertId],@"expert_id",[NSNumber numberWithLong:self.orderId],@"order_id", nil];
        [[ToolClass instance] writeReviewForExpert:params viewController:self];
    }
    else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:self.txtName.text,@"name",self.txtMessage.text,@"content",[NSNumber numberWithFloat:self.ratingView.rating],@"rate",token,@"token", nil];
        [[ToolClass instance] writeReviewForNG:params viewController:self];
    }
}

- (void) hideKeyboard {
    [self.txtName resignFirstResponder];
    [self.txtMessage resignFirstResponder];
}

- (void) handleSingleTap:(UITapGestureRecognizer*)recognizer {
    [self hideKeyboard];
    
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (void) submitReviewSuccessful {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Successful" message:@"Thank you for your feedback." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [dialog show];
}

#pragma mark UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self closeView];
}

#pragma mark UITextFieldDelegate
- (void) textFieldDidBeginEditing:(UITextField *)textField {
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    [self hideKeyboard];
    return YES;
}

#pragma mark UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (screenSize.height == 568)
        self.view.center = CGPointMake(self.view.center.x, 200);
    else if (screenSize.height == 480)
        self.view.center = CGPointMake(self.view.center.x, 70);
}

@end
