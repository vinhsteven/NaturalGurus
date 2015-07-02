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
    
}

- (void) viewWillAppear:(BOOL)animated {
    //check for iphone 4,4s
    if (screenSize.height == 480)
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height+200)];
    else
        [self.mainScrollView setContentSize:CGSizeMake(mainScrollView.frame.size.width, screenSize.height-44)];
}

- (void) setupUI {
    self.navigationItem.title = @"Alan Smith";
    
    self.view.backgroundColor = TABLE_BACKGROUND_COLOR;
    
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
    
    NSString *status = [appointmentDict objectForKey:@"status"];
    lbStatus.text = status;
    if ([status isEqualToString:@"Confirmed"])
        lbStatus.textColor = GREEN_COLOR;
    else if ([status isEqualToString:@"Pending"])
        lbStatus.textColor = [UIColor colorWithRed:(float)215/255 green:(float)186/255 blue:(float)53/255 alpha:1.0];
    else
        lbStatus.textColor = [UIColor colorWithRed:(float)215/255 green:(float)53/255 blue:(float)53/255 alpha:1.0];
    
    //set Service name label text
    self.lbServiceName.text = [appointmentDict objectForKey:@"serviceName"];
    
    //get expert image
    UIImageView *se = self.imgExpertView;
    
    NSString *imgUrl = [appointmentDict objectForKey:@"imageUrl"];
    [self.imgExpertView sd_setImageWithURL:[NSURL URLWithString:imgUrl]
                       placeholderImage:[UIImage imageNamed:NSLocalizedString(@"image_loading_placeholder", nil)]
                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,NSURL *url) {
                                  
                                  se.image = [[ToolClass instance] imageByScalingAndCroppingForSize:CGSizeMake(EXPERT_IN_LIST_WIDTH, EXPERT_IN_LIST_HEIGHT) source:image];
                                  
                              }];
    self.imgExpertView.layer.cornerRadius  = EXPERT_IMAGE_WIDTH/2;
    self.imgExpertView.layer.masksToBounds = YES;
    
    //get number of star
    //set number of rating
    self.starRatingView.backgroundImage = nil;
    self.starRatingView.starImage = [UIImage imageNamed:@"star_highlighted.png"];
    self.starRatingView.starHighlightedImage = [UIImage imageNamed:@"star.png"];
    self.starRatingView.maxRating = 5.0;
    self.starRatingView.horizontalMargin = 0;
    self.starRatingView.editable    = NO;
    self.starRatingView.rating = 3.5;
    self.starRatingView.displayMode = EDStarRatingDisplayAccurate;
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
