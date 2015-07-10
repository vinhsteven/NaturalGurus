//
//  DetailAppointmentViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "EDStarRating.h"

@interface DetailAppointmentViewController : UIViewController <UIAlertViewDelegate> {
    CGSize screenSize;
    int userRole;
}

@property (strong, nonatomic) NSDictionary *appointmentDict;
@property (strong, nonatomic) NSDictionary *expertDict;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imgExpertView;
@property (strong, nonatomic) IBOutlet UILabel *lbServiceName;
@property (strong, nonatomic) IBOutlet UILabel *lbStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnEnter;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;
@property (strong, nonatomic) IBOutlet EDStarRating *starRatingView;
@property (strong, nonatomic) IBOutlet UILabel *lbPrice;

//Detail View
@property (strong, nonatomic) IBOutlet UIView *detailContainerView;
@property (strong, nonatomic) IBOutlet UILabel *lbDetailTitle;
@property (strong ,nonatomic) IBOutlet UIButton *btnCollapseExpand;
@property (strong, nonatomic) IBOutlet UILabel *lbExpertName;
@property (strong, nonatomic) IBOutlet UILabel *lbTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lbDuration;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbTime;
@property (strong, nonatomic) IBOutlet UILabel *lbTimezone;
@property (strong, nonatomic) IBOutlet UIView *myFrontView;

@property (strong, nonatomic) IBOutlet UILabel *lbMessageTitle;
@property (strong, nonatomic) IBOutlet UIView *secondContainerView;
@property (strong, nonatomic) IBOutlet UITextView *txtMessage;

- (IBAction) handleCollapseExpandView:(id)sender;
- (IBAction) handleEnterRoom:(id)sender;
- (IBAction) handleCancelAppointment:(id)sender;

- (void) reorganizeData;

@end
