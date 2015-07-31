//
//  ConfirmedViewController.h
//  NaturalGurus
//
//  Created by Steven Pham on 7/8/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmedViewController : UIViewController <TTTAttributedLabelDelegate> {
    CGSize screenSize;
}

@property (assign, readwrite) BOOL isFreeSession;
@property (strong, nonatomic) IBOutlet UILabel *lbTitle;
@property (strong, nonatomic) IBOutlet TTTAttributedLabel *lbReferFAQ;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
