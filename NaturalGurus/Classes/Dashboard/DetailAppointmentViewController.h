//
//  DetailAppointmentViewController.h
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface DetailAppointmentViewController : UIViewController <UIAlertViewDelegate> {
    CGSize screenSize;
    
}

@property (weak, nonatomic) NSDictionary *appointmentDict;
@property (strong, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imgExpertView;
@property (strong, nonatomic) IBOutlet UILabel *lbServiceName;
@property (strong, nonatomic) IBOutlet UILabel *lbStatus;
@property (strong, nonatomic) IBOutlet UIButton *btnEnter;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

//Detail View
@property (strong, nonatomic) IBOutlet UIView *detailContainerView;
@property (strong ,nonatomic) IBOutlet UIButton *btnCollapseExpand;
@property (strong, nonatomic) IBOutlet UILabel *lbExpertName;
@property (strong, nonatomic) IBOutlet UILabel *lbTotalPrice;
@property (strong, nonatomic) IBOutlet UILabel *lbDuration;
@property (strong, nonatomic) IBOutlet UILabel *lbDate;
@property (strong, nonatomic) IBOutlet UILabel *lbTime;

- (IBAction) handleCollapseExpandView:(id)sender;
- (IBAction) handleEnterRoom:(id)sender;
- (IBAction) handleCancelAppointment:(id)sender;

@end
