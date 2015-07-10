//
//  DetailAppointmentViewController.m
//  NaturalGurus
//
//  Created by Steven on 6/16/15.
//  Copyright (c) 2015 Nhuan Quang Company Limited. All rights reserved.
//

#import "DetailAppointmentViewController.h"
#import "StreamingVideoViewController.h"

enum {
    kEnterRoomDialog = 1,
    kCancelAppointmentDialog
};

@interface DetailAppointmentViewController ()

@end

@implementation DetailAppointmentViewController
@synthesize appointmentDict;
@synthesize mainScrollView;
@synthesize btnEnter,btnCancel;
@synthesize lbStatus;
@synthesize detailContainerView;
@synthesize btnCollapseExpand;

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationPortraitUpsideDown;
}

-(BOOL)prefersStatusBarHidden{
    return HIDE_STATUS_BAR;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    [self setupUI];
    
    userRole = [[ToolClass instance] getUserRole];
    if (userRole == isUser)
        [self loadDetailExpert];
}

- (void) viewWillAppear:(BOOL)animated {
    //check for iphone 4,4s
    if (screenSize.height == 480)
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height+200)];
    else
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
}

- (void) setupUI {
    self.navigationItem.title = @"";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.myFrontView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.detailContainerView.layer.cornerRadius  = 5;
    self.detailContainerView.layer.masksToBounds = YES;
    self.detailContainerView.backgroundColor = [UIColor whiteColor];
    self.detailContainerView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.detailContainerView.layer.borderWidth = 1;
    
    self.secondContainerView.layer.cornerRadius  = 5;
    self.secondContainerView.layer.masksToBounds = YES;
    self.secondContainerView.backgroundColor = [UIColor whiteColor];
    self.secondContainerView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.secondContainerView.layer.borderWidth = 1;
    
    //style for detail label
    self.lbDetailTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    self.lbDetailTitle.textColor = GREEN_COLOR;
    
    self.lbMessageTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    self.lbMessageTitle.textColor = GREEN_COLOR;
    
    //style for enter room button
    self.btnEnter.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    self.btnEnter.layer.cornerRadius = 5;
    self.btnEnter.layer.masksToBounds = YES;
    [self.btnEnter setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
    [self.btnEnter setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //style for cancel button
    [self.btnCancel setTitleColor:[UIColor colorWithRed:(float)215/255 green:(float)53/255 blue:(float)53/255 alpha:1.0] forState:UIControlStateNormal];
    [self.btnCancel setBackgroundImage:[ToolClass imageFromColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    
    //get appointment data
    self.lbStatus.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
    
    //set Service name label text
//    self.lbServiceName.text = [appointmentDict objectForKey:@"serviceName"];
    
    //get number of star
    self.starRatingView.backgroundImage = nil;
    self.starRatingView.starImage = [UIImage imageNamed:@"star_highlighted.png"];
    self.starRatingView.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    self.starRatingView.maxRating = 5.0;
    self.starRatingView.horizontalMargin = 0;
    self.starRatingView.editable    = NO;
    self.starRatingView.displayMode = EDStarRatingDisplayAccurate;
}

- (void) loadDetailExpert {
    unsigned long expertId = [[appointmentDict objectForKey:@"expertId"] longValue];
    [[ToolClass instance] loadDetailExpertById:expertId withViewController:self];
}

- (void) reorganizeData {
    
    
    self.navigationItem.title = [self.expertDict objectForKey:@"name"];
    
    //get expert image
    UIImageView *se = self.imgExpertView;
    
    NSString *avatar = [self.expertDict objectForKey:@"avatar"];
    //add %20 if there are some space in link
    avatar = [avatar stringByReplacingOccurrencesOfString:@" " withString:@"\%20"];
    
    NSString *imgUrl = avatar;
    [self.imgExpertView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                          placeholderImage:[UIImage imageNamed:@"avatarDefault.png"]
                                 completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *url) {
                                     
                                     se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IN_LIST_WIDTH, EXPERT_IN_LIST_HEIGHT) source:image];
                                     
                                 }];
    self.imgExpertView.layer.cornerRadius  = EXPERT_IMAGE_WIDTH/2;
    self.imgExpertView.layer.masksToBounds = YES;
    
    //rating
    float rating = [[self.expertDict objectForKey:@"rating"] floatValue];
    self.starRatingView.rating = rating;
    
    //title
    self.lbServiceName.text = [self.expertDict objectForKey:@"title"];
    
    //price
    self.lbPrice.text = [NSString stringWithFormat:@"%.2f per minute",[[self.expertDict objectForKey:@"price"] floatValue]];
    
    //status
    int status = [[appointmentDict objectForKey:@"status"] intValue];
    NSString *statusString;
    UIColor *statusColor;
    switch (status) {
        case isPending:
            statusString = @"Pending";
            statusColor = [UIColor colorWithRed:(float)215/255 green:(float)186/255 blue:(float)53/255 alpha:1.0];
            self.btnEnter.userInteractionEnabled = NO;
            self.btnEnter.alpha = 0.7;
            break;
        case isApproved:
            statusString = @"Approved";
            statusColor  = GREEN_COLOR;
            break;
        case isDeclined:
            statusString = @"Declined";
            statusColor  = [UIColor colorWithRed:(float)215/255 green:(float)53/255 blue:(float)53/255 alpha:1.0];
            self.btnEnter.hidden = YES;
            break;
        case isExpired:
            statusString = @"Expired";
            statusColor  = [UIColor colorWithRed:(float)215/255 green:(float)53/255 blue:(float)53/255 alpha:1.0];
            self.btnEnter.hidden = YES;
            break;
        default:
            break;
    }
    self.lbStatus.text = statusString;
    self.lbStatus.textColor = statusColor;
    
    //set appointment value
    self.lbDuration.text = [NSString stringWithFormat:@"%d mins",[[appointmentDict objectForKey:@"duration"] intValue]];
    self.lbTotalPrice.text = [NSString stringWithFormat:@"$%.2f",[[appointmentDict objectForKey:@"total"] floatValue]];
    
    NSString *date = [appointmentDict objectForKey:@"date"];
    date = [ToolClass dateByFormat:@"EEE, MMM dd yyyy" dateString:date];
    self.lbDate.text = date;
    
    NSString *fromTime  = [ToolClass convertHourToAM_PM:[appointmentDict objectForKey:@"from_time"]];
    NSString *toTime    = [ToolClass convertHourToAM_PM:[appointmentDict objectForKey:@"to_time"]];
    self.lbTime.text    = [NSString stringWithFormat:@"%@ - %@",fromTime,toTime];

    self.lbTimezone.text = [appointmentDict objectForKey:@"timezone"];
}

- (IBAction) handleCollapseExpandView:(id)sender {
    if (!detailContainerView.hidden) {
        [btnCollapseExpand setBackgroundImage:[UIImage imageNamed:@"btnExpand.png"] forState:UIControlStateNormal];
        
        //restore
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
    }
    else {
        [btnCollapseExpand setBackgroundImage:[UIImage imageNamed:@"btnCollapse.png"] forState:UIControlStateNormal];
        
        //check for iphone 4,4s
        if (screenSize.height == 480)
            [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height+200)];
        else
            [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
    }
    detailContainerView.hidden = !detailContainerView.hidden;
}

- (IBAction) handleEnterRoom:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Enter Appointment" message:@"You are about to enter the meeting room." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel", nil];
    dialog.tag = kEnterRoomDialog;
    [dialog show];
}

- (IBAction) handleCancelAppointment:(id)sender {
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"Important" message:@"Cancellation will incur a 10% penalty fee." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",@"Cancel", nil];
    dialog.tag = kCancelAppointmentDialog;
    [dialog show];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kEnterRoomDialog) {
        if (buttonIndex == 0) {
            //ok enter meeting room
            StreamingVideoViewController *controller = [[StreamingVideoViewController alloc] init];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
