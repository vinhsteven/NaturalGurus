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
    else
        [self loadDetailUser];
    
    self.navigationItem.title = [appointmentDict objectForKey:@"name"];
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
    
    //check if this appointment is finished, don't show Enter Room button
    int video_state = [[appointmentDict objectForKey:@"video_state"] intValue];
    if (video_state == 1){
        statusString = @"Finished";
        statusColor  = ORANGE_COLOR;
        self.btnEnter.hidden = YES;
    }
    
    self.lbStatus.text = statusString;
    self.lbStatus.textColor = statusColor;
    
    if (userRole != isUser && status == isPending) {
        //check display or not 2 button Accept or Decline
        //hide enter meeting room
        self.btnEnter.hidden = YES;
        
        //alloc Accept button
        btnAccept = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAccept.tag = 1;
        btnAccept.backgroundColor = [UIColor lightGrayColor];
        [btnAccept setTitle:@"Accept" forState:UIControlStateNormal];
        btnAccept.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        [btnAccept setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnAccept addTarget:self action:@selector(handleUpdateAppointmentState:) forControlEvents:UIControlEventTouchUpInside];
        [btnAccept setBackgroundImage:[ToolClass imageFromColor:GREEN_COLOR] forState:UIControlStateNormal];
        btnAccept.layer.cornerRadius  = 5;
        btnAccept.layer.masksToBounds = YES;
        
        //alloc Decline button
        btnDecline = [UIButton buttonWithType:UIButtonTypeCustom];
        btnDecline.backgroundColor = [UIColor lightGrayColor];
        [btnDecline setTitle:@"Decline" forState:UIControlStateNormal];
        btnDecline.titleLabel.font = [UIFont fontWithName:DEFAULT_FONT_BOLD size:13];
        [btnDecline setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnDecline addTarget:self action:@selector(handleUpdateAppointmentState:) forControlEvents:UIControlEventTouchUpInside];
        [btnDecline setBackgroundImage:[ToolClass imageFromColor:RED_COLOR] forState:UIControlStateNormal];
        btnDecline.layer.cornerRadius  = 5;
        btnDecline.layer.masksToBounds = YES;
        
        int bottomPadding = 10;
        int leftPadding = 10;
        int height = 45;
        
        btnAccept.frame = CGRectMake(leftPadding, screenSize.height - bottomPadding - height, (screenSize.width-3*leftPadding)/2, height);
        
        btnDecline.frame = CGRectMake(2*leftPadding + btnAccept.frame.size.width, btnAccept.frame.origin.y, btnAccept.frame.size.width, btnAccept.frame.size.height);
        
        [self.view addSubview:btnAccept];
        [self.view addSubview:btnDecline];
    }
    
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
    
    [self performSelector:@selector(delayForLayout) withObject:nil afterDelay:0.5];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [self performSelectorInBackground:@selector(loadVideoToken) withObject:nil];
    
    //check for expert flow if user update data successfully
    if (self.isFinishMeeting) {
        //has used
        self.lbStatus.text = @"Finished";
        self.lbStatus.textColor = ORANGE_COLOR;
        self.btnEnter.hidden = YES;
        
        [appointmentDict setObject:[NSNumber numberWithInt:1] forKey:@"video_state"];
    }
}

- (void) delayForLayout {
    NSString *messageText = [appointmentDict objectForKey:@"about"];
    
    UITextView *view = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 10)];
    view.text = messageText;
    CGSize size = [view sizeThatFits:CGSizeMake(screenSize.width, CGFLOAT_MAX)];
    
    UIView *aboutView = [[UIView alloc] initWithFrame:CGRectMake(10, self.detailContainerView.frame.origin.y+self.detailContainerView.frame.size.height+14, screenSize.width-20, size.height + 40)];
    
    aboutView.layer.cornerRadius  = 5;
    aboutView.layer.masksToBounds = YES;
    aboutView.backgroundColor = [UIColor whiteColor];
    aboutView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    aboutView.layer.borderWidth = 1;
    [self.mainScrollView addSubview:aboutView];
    
    UILabel *lbMessage = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 97, 21)];
    lbMessage.text = @"Message";
    lbMessage.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    lbMessage.textColor = GREEN_COLOR;
    [aboutView addSubview:lbMessage];
    
    UITextView *txtView = [[UITextView alloc] initWithFrame:CGRectMake(10, lbMessage.frame.origin.y + lbMessage.frame.size.height + 10, screenSize.width-10, 10)];
    txtView.userInteractionEnabled = NO;
    txtView.text = messageText;
    
    txtView.frame = CGRectMake(0, lbMessage.frame.origin.y + lbMessage.frame.size.height, aboutView.frame.size.width, size.height+10);
    txtView.textContainerInset = UIEdgeInsetsMake(5.0, 5.0, 0.0, 0.0);
    [aboutView addSubview:txtView];
    
    //check for iphone 4,4s
    [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, aboutView.frame.origin.y + aboutView.frame.size.height)];
}

- (void) loadVideoToken {
    long appointmentId = [[appointmentDict objectForKey:@"appointmentId"] longValue];
    
    NSString *token = [[ToolClass instance] getUserToken];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    
    if (userRole == isUser)
        [[ToolClass instance] loadUserVideoToken:appointmentId params:params withViewController:self];
    else
        [[ToolClass instance] loadExpertVideoToken:appointmentId params:params withViewController:self];
}

- (void) handleGetVideoTokenFailedWithMessage:(NSString*)message {
    if ([message rangeOfString:@"used or expired"].location == NSNotFound) {
        //dont used
    }
    else {
        [appointmentDict setObject:[NSNumber numberWithInt:1] forKey:@"video_state"];
        //has used
        self.lbStatus.text = @"Finished";
        self.lbStatus.textColor = ORANGE_COLOR;
        self.btnEnter.hidden = YES;
        [appointmentDict setObject:[NSNumber numberWithInt:1] forKey:@"video_state"];
    }
}

- (void) setupUI {
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.myFrontView.backgroundColor = TABLE_BACKGROUND_COLOR;
    
    self.topView.backgroundColor = [UIColor colorWithRed:(float)245/255 green:(float)245/255 blue:(float)245/255 alpha:1.0];
    
    //add bottom line of top view
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 44, screenSize.width, 1)];
    view.backgroundColor = LIGHT_GREY_COLOR;
    [self.topView addSubview:view];
    
    self.lbTime.textColor = GREEN_COLOR;
    
    self.detailContainerView.layer.cornerRadius  = 5;
    self.detailContainerView.layer.masksToBounds = YES;
    self.detailContainerView.backgroundColor = [UIColor whiteColor];
    self.detailContainerView.layer.borderColor = LIGHT_GREY_COLOR.CGColor;
    self.detailContainerView.layer.borderWidth = 1;
    
    //style for detail label
    self.lbDetailTitle.font = [UIFont fontWithName:MONTSERRAT_BOLD size:14];
    self.lbDetailTitle.textColor = GREEN_COLOR;
    
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

- (void) loadDetailUser {
    self.starRatingView.hidden = self.lbPrice.hidden = YES;
    
    self.lbServiceName.text = [appointmentDict objectForKey:@"email"];
    
    //get expert image
    UIImageView *se = self.imgExpertView;
    
    NSString *avatar = [appointmentDict objectForKey:@"client_avatar"];
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
}

//- (IBAction) handleCollapseExpandView:(id)sender {
//    if (!detailContainerView.hidden) {
//        [btnCollapseExpand setBackgroundImage:[UIImage imageNamed:@"btnExpand.png"] forState:UIControlStateNormal];
//        
//        //restore
//        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
//    }
//    else {
//        [btnCollapseExpand setBackgroundImage:[UIImage imageNamed:@"btnCollapse.png"] forState:UIControlStateNormal];
//        
//        //check for iphone 4,4s
//        if (screenSize.height == 480)
//            [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height+200)];
//        else
//            [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
//    }
//    detailContainerView.hidden = !detailContainerView.hidden;
//}

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

- (void) handleUpdateAppointmentState:(UIButton*)sender {
    int type = (int)sender.tag;
    
    long appointmentId = [[appointmentDict objectForKey:@"appointmentId"] longValue];
    
    NSString *token = [[ToolClass instance] getUserToken];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:token,@"token", nil];
    
    [[ToolClass instance] handleUpdateAppointmentState:type appointmentId:appointmentId params:params withViewController:self];
}

- (void) handleAfterUpdateAppointmentSuccess:(int)type {
    if (type) {
        //approve
        [appointmentDict setObject:[NSNumber numberWithInt:isApproved] forKey:@"status"];
        
        btnAccept.hidden = btnDecline.hidden = YES;
        self.btnEnter.hidden = NO;
        self.btnEnter.alpha = 1.0;
        self.btnEnter.userInteractionEnabled = YES;
        
        self.lbStatus.text = @"Approved";
        self.lbStatus.textColor = GREEN_COLOR;
    }
    else {
        //decline
        [appointmentDict setObject:[NSNumber numberWithInt:isDeclined] forKey:@"status"];
        
        btnAccept.hidden = btnDecline.hidden = YES;
        
        self.lbStatus.text = @"Declined";
        self.lbStatus.textColor = RED_COLOR;
    }
}

- (IBAction) closeView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == kEnterRoomDialog) {
        if (buttonIndex == 0) {
            //ok enter meeting room
            StreamingVideoViewController *controller = [[StreamingVideoViewController alloc] init];
            controller.kApiKey = [self.videoDict objectForKey:@"apiKey"];
            controller.kSessionId = [self.appointmentDict objectForKey:@"video_session"];
            controller.kToken   = [self.videoDict objectForKey:@"token"];
            
            controller.parent = self;
            controller.appointmentId = [[self.appointmentDict objectForKey:@"appointmentId"] longValue];
            controller.duration = [[self.videoDict objectForKey:@"sessionLength"] intValue];
            [self presentViewController:controller animated:YES completion:nil];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
